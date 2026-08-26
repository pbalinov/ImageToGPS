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

## Requirements

- macOS 13.0 or later *(or iOS/iPadOS 16.0+)*
- Xcode 15.0 or later
- Swift 5.9+

---

QuitRunningApps is a macOS application built with SwiftUI. It automates the process of closing multiple running applications on your Mac with a single click.

QuitRunningApps follows SwiftUI principles and Apple’s recommended best practices.

The latest version of the application is available on the [Releases](https://github.com/pbalinov/QuitRunningApps/releases) page.

User and installation guides can be found in the [Wiki](https://github.com/pbalinov/QuitRunningApps/wiki).

You can contact me at quitrunningapps@gmail.com.

Created by Plamen Balinov.
