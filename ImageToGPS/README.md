# ImageToGPS

A lightweight and fast macOS application built with SwiftUI to inspect EXIF metadata, extract GPS coordinates, and preview image thumbnails from local files and the Photo Library.

## Features

- **Fast EXIF GPS Extraction**: Reads latitude and longitude coordinates directly from image metadata using `ImageIO`.
- **Thumbnail Generation**: Efficiently generates embedded thumbnails on background tasks using `CGImageSourceCreateThumbnailAtIndex` without loading full-resolution images into memory.
- **Batch Selection**: Select multiple images at once using the native file importer or the Photos picker.
- **Copy Coordinates**:
  - Selectable text with standard copy-paste (⌘ + C).
  - One-click copy button per row.
  - Context menu (right-click) support.
- **Fully Asynchronous & Responsive**: Uses Swift Concurrency (`Task` and `withTaskGroup` with utility QoS) to keep the UI fluid during image processing.
- **Localization-ready**: String identifiers configured for easy localization.

## Requirements

- macOS 14.0+ (or targeted deployment version)
- Xcode 15.0+
- Swift 5.9+

## Tech Stack & Frameworks

- **SwiftUI**: Modern, declarative UI with `Table` and `PhotosPicker`.
- **ImageIO**: Low-level, memory-efficient image property and thumbnail extraction.
- **Swift Concurrency**: Structured concurrency (`TaskGroup`) for parallel processing.
- **UniformTypeIdentifiers**: Type-safe file type handling.
