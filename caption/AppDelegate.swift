////
////  AppDelegate.swift
////  tag
/////Users/mileswilson/repos/projects/caption/caption/AppDelegate.swift
////  Created by Miles Wilson on 5/27/25.
////
//
//import Foundation
//import AppKit
//import SwiftUI
//import SwiftData
//
//class AppDelegate: NSObject, NSApplicationDelegate {
//    var statusBarItem: NSStatusItem!
//    var clipboardManager: ClipboardManager!
//    var popover: NSPopover!
//    var sharedModelContainer: ModelContainer!
//    
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        // Create status bar item FIRST
//        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//        
//        if let button = statusBarItem.button {
//            // Use a system image that's guaranteed to exist
//            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard Manager")
//            // Fallback if system symbol doesn't work
//            if button.image == nil {
//                button.title = "📋"
//            }
//            button.action = #selector(togglePopover(_:))
//            button.target = self
//        }
//        
//        // Initialize clipboard manager
//        clipboardManager = ClipboardManager()
//        
//        let view = ClipboardView(manager: clipboardManager).modelContainer(sharedModelContainer)
//        
//        // Create popover with larger size for tags sidebar
//        popover = NSPopover()
//        popover.contentSize = NSSize(width: 600, height: 500)
//        popover.behavior = .transient
//        popover.contentViewController = NSHostingController(rootView: view)
//        
//        // Hide dock icon AFTER everything is set up
//        NSApp.setActivationPolicy(.accessory)
//        
//        // Keep the app running
//        NSApp.activate(ignoringOtherApps: true)
//    }
//    
//    @objc func togglePopover(_ sender: AnyObject?) {
//        if let button = statusBarItem.button {
//            if popover.isShown {
//                popover.performClose(sender)
//            } else {
//                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
//            }
//        }
//    }
//}
