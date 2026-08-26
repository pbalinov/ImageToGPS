//
//  Functions.swift
//  ImageToGPS
//
//  Created by Plamen Balinov on 26.08.26.
//

import Foundation
import Cocoa

func openURL(_ link: URL) {
    NSWorkspace.shared.open(link)
}

func openPDFFromBundle(_ pdf: String) {
    
    if let pathToPDF = Bundle.main.path(forResource: pdf, ofType: "pdf") {
        let pdfURL = URL(fileURLWithPath: pathToPDF)
        NSWorkspace.shared.open(pdfURL)
    }
}

func validateString(_ str: String?) -> Bool {
    
    // Return true if string is not null
    // or empty otherwise return false
    
    guard let validateString = str else {
        return false
    }
    
    return !validateString.isEmpty
}
