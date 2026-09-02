//
//  ContentView.swift
//  ImageToGPS
//
//  Created by Plamen Balinov on 26.08.26.
//

import SwiftUI
import UniformTypeIdentifiers
import ImageIO
import PhotosUI

struct PhotoItem: Identifiable, Sendable {
    let id = UUID()
    var imgThumbnail: Image?
    var fileName: String
    var gpsCoordinates: String
    var hasValidGPS: Bool = false
}

struct ContentView: View {
    @State private var listOfPhotos: [PhotoItem] = []
    @State private var isImporterPresented: Bool = false
    @State private var selectedLibraryItems: [PhotosPickerItem] = []
    @State private var loadStatusMessage: String = ""
    @State private var isLoadStatusError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Table.spacing) {
            
            Text("table-title")
                .font(.headline)
                
            Table(listOfPhotos) {
                TableColumn("table-column-photo") { item in
                    Group {
                        if let thumbnail = item.imgThumbnail {
                            thumbnail
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: Constants.Table.thumbWidth, height: Constants.Table.thumbHeight)
                    .clipped()
                    .cornerRadius(Constants.Table.thumbCornerRadius)
                }
                .width(Constants.Table.thumbColumnWidth)

                TableColumn("table-column-file") { item in
                    Text(item.fileName)
                        .textSelection(.enabled)
                }
                TableColumn("table-column-gps") { item in
                    HStack {
                        Text(item.gpsCoordinates)
                            .textSelection(.enabled)

                        if item.hasValidGPS {
                            Button {
                                copyToClipboard(item.gpsCoordinates)
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.borderless)
                            .help(Text("copy-coordinates"))
                        }
                    }
                    .contextMenu(item.hasValidGPS ? ContextMenu {
                        Button {
                            copyToClipboard(item.gpsCoordinates)
                        } label: {
                            Label("copy-coordinates", systemImage: "doc.on.doc")
                        }
                    } : nil)
                }
            }

            HStack {
                if !loadStatusMessage.isEmpty {
                    Text(loadStatusMessage)
                        .font(.caption)
                        .foregroundStyle(isLoadStatusError ? .red : .secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 240, alignment: .trailing)
                }
                
                Spacer()
                
                Button("button-load-files") {
                    isImporterPresented = true
                }
                .buttonStyle(.borderedProminent)
                
                PhotosPicker(
                    "button-load-library",
                    selection: $selectedLibraryItems,
                    matching: .images
                )
                .buttonStyle(.bordered)
                .onChange(of: selectedLibraryItems) { _, items in
                    loadPhotosFromLibrary(from: items)
                }
            }
        }
        .padding()
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.image],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                loadPhotosFromFiles(from: urls)
            case .failure(let error):
                isLoadStatusError = true
                loadStatusMessage = String(
                    format: NSLocalizedString("load-selection-error", comment: ""),
                    error.localizedDescription
                )
            }
        }
    }

    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)    
    }

    private func loadPhotosFromFiles(from urls: [URL]) {
        showLoadingStatus()

        Task(priority: .utility) {
            let result = await withTaskGroup(of: (index: Int, item: PhotoItem?).self) { group in
                for (index, url) in urls.enumerated() {
                    group.addTask {
                        (index, Self.processPhoto(at: url))
                    }
                }
                
                var loadedItems: [(index: Int, item: PhotoItem)] = []
                var failedCount = 0
                for await result in group {
                    if let item = result.item {
                        loadedItems.append((result.index, item))
                    } else {
                        failedCount += 1
                    }
                }

                let items = loadedItems
                    .sorted { $0.index < $1.index }
                    .map(\.item)

                return (items: items, failedCount: failedCount)
            }

            self.listOfPhotos = result.items
            self.showCompletionStatus(loadedCount: result.items.count, failedCount: result.failedCount)
        }
    }

    private func loadPhotosFromLibrary(from pickerItems: [PhotosPickerItem]) {
        guard !pickerItems.isEmpty else { return }

        showLoadingStatus()

        Task(priority: .utility) {
            let result = await withTaskGroup(of: (index: Int, item: PhotoItem?).self) { group in
                for (index, item) in pickerItems.enumerated() {
                    group.addTask {
                        guard let data = try? await item.loadTransferable(type: Data.self) else {
                            return (index, nil)
                        }

                        let name = item.itemIdentifier ?? "Photo \(index + 1)"
                        return (index, Self.processPhotoData(data, fileName: name))
                    }
                }

                var loadedItems: [(index: Int, item: PhotoItem)] = []
                var failedCount = 0
                for await result in group {
                    if let item = result.item {
                        loadedItems.append((result.index, item))
                    } else {
                        failedCount += 1
                    }
                }

                let items = loadedItems
                    .sorted { $0.index < $1.index }
                    .map(\.item)

                return (items: items, failedCount: failedCount)
            }

            self.listOfPhotos = result.items
            self.showCompletionStatus(loadedCount: result.items.count, failedCount: result.failedCount)
            self.selectedLibraryItems = []
        }
    }

    private func showLoadingStatus() {
        isLoadStatusError = false
        loadStatusMessage = NSLocalizedString("load-loading", comment: "")
    }

    private func showCompletionStatus(loadedCount: Int, failedCount: Int) {
        isLoadStatusError = failedCount > 0

        if failedCount > 0 {
            loadStatusMessage = String(
                format: NSLocalizedString("load-partial-count", comment: ""),
                loadedCount,
                failedCount
            )
        } else {
            loadStatusMessage = String(
                format: NSLocalizedString("load-loaded-count", comment: ""),
                loadedCount
            )
        }
    }

    nonisolated private static func processPhoto(at url: URL) -> PhotoItem? {
        let isAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let sourceOptions: [CFString: Any] = [
            kCGImageSourceShouldCache: false
        ]
        
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, sourceOptions as CFDictionary) else {
            return nil
        }

        return makePhotoItem(from: imageSource, fileName: url.lastPathComponent)
    }

    nonisolated private static func processPhotoData(_ data: Data, fileName: String) -> PhotoItem? {
        let sourceOptions: [CFString: Any] = [
            kCGImageSourceShouldCache: false
        ]

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, sourceOptions as CFDictionary) else {
            return nil
        }

        return makePhotoItem(from: imageSource, fileName: fileName)
    }

    nonisolated private static func makePhotoItem(from imageSource: CGImageSource, fileName: String) -> PhotoItem {
        let thumbnailOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 250,
            kCGImageSourceShouldCacheImmediately: true
        ]
        
        var thumbnailImage: Image?
        if let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary) {
            thumbnailImage = Image(decorative: cgImage, scale: 1.0)
        }

        let (coordinatesString, hasValidGPS) = extractGPSCoordinates(from: imageSource)

        return PhotoItem(
            imgThumbnail: thumbnailImage,
            fileName: fileName,
            gpsCoordinates: coordinatesString,
            hasValidGPS: hasValidGPS
        )
    }

    nonisolated private static func extractGPSCoordinates(from source: CGImageSource) -> (coordinates: String, isValid: Bool) {
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let gpsData = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any]
        else {
            return (NSLocalizedString("gps-no-data", comment: ""), false)
        }

        guard let latitude = gpsData[kCGImagePropertyGPSLatitude] as? Double,
              let latRef = gpsData[kCGImagePropertyGPSLatitudeRef] as? String,
              let longitude = gpsData[kCGImagePropertyGPSLongitude] as? Double,
              let lonRef = gpsData[kCGImagePropertyGPSLongitudeRef] as? String
        else {
            return (NSLocalizedString("gps-incomplete-data", comment: ""), false)
        }

        let signedLatitude = signedCoordinate(latitude, reference: latRef)
        let signedLongitude = signedCoordinate(longitude, reference: lonRef)

        return (String(format: "%.5f, %.5f", signedLatitude, signedLongitude), true)
    }

    nonisolated private static func signedCoordinate(_ value: Double, reference: String) -> Double {
        switch reference.uppercased() {
        case "S", "W":
            return -abs(value)
        default:
            return abs(value)
        }
    }
}

#Preview {
    ContentView()
}
