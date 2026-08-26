//
//  ContentView.swift
//  ImageToGPS
//
//  Created by Plamen Balinov on 26.08.26.
//

import SwiftUI
import UniformTypeIdentifiers
import ImageIO

struct PhotoItem: Identifiable, Sendable {
    let id = UUID()
    var imgThumbnail: Image?
    var fileName: String
    var gpsCoordinates: String
}

struct ContentView: View {
    @State private var listOfPhotos: [PhotoItem] = []
    @State private var isImporterPresented: Bool = false

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

                        //Spacer()

                        Button {
                            copyToClipboard(item.gpsCoordinates)
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(.borderless)
                        .help(Text("copy-coordinates"))
                    }
                    .contextMenu {
                        Button {
                            copyToClipboard(item.gpsCoordinates)
                        } label: {
                            Label("copy-coordinates", systemImage: "doc.on.doc")
                        }
                    }
                }
            }

            HStack {
                Spacer()
                
                Button("button-load") {
                    isImporterPresented = true
                }
                .buttonStyle(.borderedProminent)
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
                loadPhotos(from: urls)
            case .failure(let error):
                print("Failed to select photos: \(error.localizedDescription)")
            }
        }
    }

    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)    
    }

    private func loadPhotos(from urls: [URL]) {
        Task {
            let items = await Task.detached(priority: .userInitiated) {
                var loadedItems: [PhotoItem] = []

                for url in urls {
                    let isAccessing = url.startAccessingSecurityScopedResource()
                    defer {
                        if isAccessing {
                            url.stopAccessingSecurityScopedResource()
                        }
                    }

                    guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
                        continue
                    }

                    // Generate thumbnail
                    let thumbnailOptions: [CFString: Any] = [
                        kCGImageSourceCreateThumbnailWithTransform: true,
                        kCGImageSourceCreateThumbnailFromImageAlways: true,
                        kCGImageSourceThumbnailMaxPixelSize: 250
                    ]
                    var thumbnailImage: Image?
                    if let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary) {
                        thumbnailImage = Image(decorative: cgImage, scale: 1.0)
                    }

                    // Extract GPS coordinates
                    let coordinatesString = Self.extractGPSCoordinates(from: imageSource)

                    let photoItem = PhotoItem(
                        imgThumbnail: thumbnailImage,
                        fileName: url.lastPathComponent,
                        gpsCoordinates: coordinatesString
                    )
                    loadedItems.append(photoItem)
                }

                return loadedItems
            }.value

            self.listOfPhotos = items
        }
    }

    nonisolated private static func extractGPSCoordinates(from source: CGImageSource) -> String {
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let gpsData = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any]
        else {
            return NSLocalizedString("gps-no-data", comment: "")
        }

        guard let latitude = gpsData[kCGImagePropertyGPSLatitude] as? Double,
              let latRef = gpsData[kCGImagePropertyGPSLatitudeRef] as? String,
              let longitude = gpsData[kCGImagePropertyGPSLongitude] as? Double,
              let lonRef = gpsData[kCGImagePropertyGPSLongitudeRef] as? String
        else {
            return NSLocalizedString("gps-incomplete-data", comment: "")
        }

        return String(format: "%.5f° %@, %.5f° %@", latitude, latRef, longitude, lonRef)
    }
}

#Preview {
    ContentView()
}
