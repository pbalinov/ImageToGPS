# ImageToGPS

A lightweight, native macOS utility built with SwiftUI that extracts and displays GPS metadata (EXIF) and thumbnails from your photo files in a clean, interactive table.

---

## Features

- Fast EXIF GPS Extraction: Reads latitude and longitude coordinates directly from image metadata using `ImageIO`.
- Thumbnail Generation: Efficiently generates embedded thumbnails on a background thread without loading full-resolution images into memory.
- Batch Selection: Select multiple images at once using the native file importer.
- Copy Coordinates: 
  - Selectable text with standard copy-paste (<kbd>⌘</kbd> + <kbd>C</kbd>).
  - One-click copy button per row.
  - Context menu (right-click) support.
- Fully Asynchronous & Responsive: Uses Swift Concurrency (`Task.detached` with appropriate QoS) to keep the UI fluid during image processing.
- Localization-ready: String identifiers configured for easy localization.

---

The latest version of the application is available on the [Releases](https://github.com/pbalinov/ImageToGPS/releases) page.

User and installation guides can be found in the [Wiki](https://github.com/pbalinov/ImageToGPS/wiki).

Created by Plamen Balinov.
