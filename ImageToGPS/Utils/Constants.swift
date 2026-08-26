//
//  Constants.swift
//  ImageToGPS
//
//  Created by Plamen Balinov on 26.08.26.
//

import Foundation
import SwiftUI

struct Constants {
    
    struct URLs {
        // Web Site address
        static let webSite = URL(string: "https://github.com/pbalinov/ImageToGPS/")!

        // User Guide
        static let userGuide = URL(string: "https://github.com/pbalinov/ImageToGPS/wiki/How-It-Works/")!

        // JSON File with the latest app version
        static let appVersion = URL(string: "https://api.npoint.io/bfd6c134f6ae0d2f2d7b")!
        
        // Downloads page
        static let downloadsPage = URL(string: "https://github.com/pbalinov/ImageToGPS/releases/")!
    }
    
    struct MainWindow {
        // Application window dimensions
        static let width = CGFloat(600)
        static let height = CGFloat(400)
    }
        
    struct Update {
        // Period between update checks in days
        static let periodBetweenChecks = 7
    }
    
    struct Table {
        // Table properties
        static let spacing = CGFloat(16)
        static let thumbColumnWidth = CGFloat(150)
        static let thumbCornerRadius = CGFloat(6)
        static let thumbWidth = CGFloat(125)
        static let thumbHeight = CGFloat(125)
    }
}

