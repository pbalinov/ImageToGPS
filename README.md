# ImageToGPS

A lightweight and fast macOS application built with SwiftUI to inspect EXIF metadata, extract GPS coordinates, and preview image thumbnails from local files and the Photos library.

---

## Features

- **Fast EXIF GPS Extraction**: Reads latitude and longitude coordinates directly from image metadata using `ImageIO`.
- **Photo Library & File Importer Integration**:
  - Load photos directly from your system Photos library with the native `PhotosPicker`.
  - Batch select local files and folders via the native file importer dialog.
- **Batch Processing**: Select and process multiple images concurrently in parallel.
- **Copy Coordinates**:
  - Selectable text with standard copy-paste (⌘ + C).
  - One-click copy button per row.
  - Context menu (right-click) support.

---

The latest version of the application is available on the [Releases](https://github.com/pbalinov/ImageToGPS/releases) page.

User and installation guides can be found in the [Wiki](https://github.com/pbalinov/ImageToGPS/wiki).

Created by Plamen Balinov.
