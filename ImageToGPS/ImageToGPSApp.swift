//
//  ImageToGPSApp.swift
//  ImageToGPS
//
//  Created by Plamen Balinov on 26.08.26.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Close the application after last (only) window is closed
        return true
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        if #available(macOS 13, *) {
            // Run on macOS 13
            // Fixed in Xcode 14, macOS 13
        } else {
            // Run on macOS 12 and lower code.
            // Workaround for the window minimize and restore issue
            (notification.object as? NSApplication)?.windows.first?.makeKeyAndOrderFront(self)
        }
    }

}

@main
struct ImageToGPSApp: App {
    // Apply workarounds via app delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Disable tab bar menu
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
                .frame(minWidth: Constants.MainWindow.width, idealWidth: Constants.MainWindow.width, maxWidth: .infinity, minHeight: Constants.MainWindow.height, idealHeight: Constants.MainWindow.height, maxHeight: .infinity, alignment: .center)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                // Disable new window menu
            }
            CommandGroup(replacing: .systemServices) {
                // Disable system services menu
            }
            CommandGroup(replacing: .pasteboard) {
                // Disable items in Edit menu
            }
            CommandGroup(replacing: .undoRedo) {
                // Disable items in Edit menu
            }
            CommandGroup(replacing: .help) {
                Button(action: {
                    // Open the application user guide
                    openURL(Constants.URLs.userGuide)
                }) {
                    Text("help-user-guide")
                }
                
                Button(action: {
                    // // Open the application web site
                    openURL(Constants.URLs.webSite)
                }) {
                    Text("help-web-page")
                }
            }
            /*
            CommandGroup(after: .systemServices) {
                Button(action: {
                     // Check for update
                     Task {
                     await appUpdateModel.loadVersionDataAndCheckForUpdate()
                     }
                     settingsModel.setLastUpdateCheckDate(Date.now)
                }) {
                    Text("menu-updates")
                }
            }
            */
        }
    }
}
