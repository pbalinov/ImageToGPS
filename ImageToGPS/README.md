# ImageToGPS

A lightweight and fast macOS application built with SwiftUI to inspect EXIF metadata, extract GPS coordinates, and preview image thumbnails from local files and the Photos library.

## Features

- **Fast EXIF GPS Extraction**: Reads latitude and longitude coordinates directly from image metadata using `ImageIO`.
- **Photo Library & File Importer Integration**:
  - Load photos directly from your system Photos library with the native `PhotosPicker`.
  - Batch select local files and folders via the native file importer dialog.
- **Thumbnail Generation**: Efficiently generates embedded thumbnails on background tasks using `CGImageSourceCreateThumbnailAtIndex` without loading full-resolution images into memory.
- **Batch Processing**: Select and process multiple images concurrently in parallel.
- **Copy Coordinates**:
  - Selectable text with standard copy-paste (⌘ + C).
  - One-click copy button per row.
  - Context menu (right-click) support.
- **Fully Asynchronous & Responsive**: Uses Swift Concurrency (`Task` and `withTaskGroup` with utility QoS) to keep the UI fluid during image processing.
- **Localization-ready**: String identifiers configured for easy localization.

## Requirements

- macOS 14.0+
- Xcode 15.0+
- Swift 5.9+

## Tech Stack & Frameworks

- **SwiftUI**: Modern, declarative UI with multi-column `Table` view.
- **PhotosUI**: Native system `PhotosPicker` for accessing the Photos library.
- **ImageIO**: Low-level, memory-efficient image property inspection and thumbnail extraction.
- **Swift Concurrency**: Structured concurrency (`TaskGroup`) for parallel photo processing.
- **UniformTypeIdentifiers**: Type-safe file content type filtering.
