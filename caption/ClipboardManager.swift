//
//  ClipboardManager.swift
//  tag
//
//  Created by Miles Wilson on 5/27/25.
//

import Foundation
import AppKit
import SwiftData
import SwiftUI

class ClipboardManager: ObservableObject {
    private var context: ModelContext
    
    private var pasteboard = NSPasteboard.general
    private var timer: Timer?
    private var lastChangeCount: Int = 0
    private let userDefaults = UserDefaults.standard
    
    init(context: ModelContext) {
        self.context = context
//        loadHistory()
        lastChangeCount = pasteboard.changeCount
        startMonitoring()
    }
    
    deinit {
//        saveHistory()
    }
    
//    private func loadHistory() {
//        if let data = userDefaults.data(forKey: historyKey),
//           let decoded = try? JSONDecoder().decode([ClipboardItem].self, from: data) {
//            clipboardHistory = decoded
//        }
//    }
//    
//    private func saveHistory() {
//        if let encoded = try? JSONEncoder().encode(clipboardHistory) {
//            userDefaults.set(encoded, forKey: historyKey)
//        }
//    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkClipboard()
        }
    }
    
    private func checkClipboard() {
        let currentChangeCount = pasteboard.changeCount
        
        if currentChangeCount != lastChangeCount {
            lastChangeCount = currentChangeCount
            
            if let string = pasteboard.string(forType: .string), !string.isEmpty {
                addClipboardItem(content: string, type: .text)
            } else if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
                addClipboardItem(content: "Image", type: .image, image: image)
            }
        }
    }
    
    private func addClipboardItem(content: String, type: ClipboardItemType, image: NSImage? = nil) {
        // TODO: Avoid duplicates
//        if let first = clipboardHistory.first, first.content == content {
//            return
//        }
        
        let item = ClipboardItem(content: content, type: type, image: image)
        context.insert(item)
        
        // TODO: Garbage collection!
        // Keep only last 50 items
//        if clipboardHistory.count > 50 {
//            clipboardHistory.removeLast()
//        }
    }
    
    func copyToClipboard(_ item: ClipboardItem) {
        pasteboard.clearContents()
        
        switch item.type {
        case .text:
            pasteboard.setString(item.content, forType: .string)
        case .image:
            if let image = item.image {
                pasteboard.writeObjects([image])
            }
        }
        
        // TODO: Move item to top of history?
//        if let index = clipboardHistory.firstIndex(where: { $0.id == item.id }) {
//            let movedItem = clipboardHistory.remove(at: index)
//            clipboardHistory.insert(movedItem, at: 0)
//            saveHistory()
//        }
    }
    
    func deleteItem(_ item: ClipboardItem) {
        context.delete(item)
    }
    
    // TODO: Figure out
    func clearHistory() {
//        context.deleteAllData()
//        saveHistory()
    }
    
    // TODO: How do we save these?
    func updateItemTags(_ item: ClipboardItem, tags: [String]) {
//        // TODO: Does this work?
//        context.re
//        item.tags = tags
//        if let index = clipboardHistory.firstIndex(where: { $0.id == item.id }) {
//            clipboardHistory[index].tags = tags
//            saveHistory()
//        }
    }
    
//    func getAllTags() -> [String] {
//        let allTags = clipboardHistory.flatMap { $0.tags }
//        return Array(Set(allTags)).sorted()
//    }
}
