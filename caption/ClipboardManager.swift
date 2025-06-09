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
    private var clipboardTimer: Timer?
    private var cleanupTimer: Timer?
    private var lastChangeCount: Int = 0
    private let userDefaults = UserDefaults.standard
    private let cleanupQueue = DispatchQueue(label: "milesw.caption.cleanup", qos: .utility)
    // TODO: This will eventually be read in from a settings model
    @Published var isWatchingClipboard = true {
        // note that this will not trigger on initial assignment, so we start from the constructor
        didSet {
            if isWatchingClipboard {
                startClipboardMonitoring()
            } else {
                stopClipboardMonitoring()
            }
        }
    }
    
    init(context: ModelContext) {
        self.context = context
        lastChangeCount = pasteboard.changeCount
        startClipboardMonitoring()
        startGarbageCollection()
    }

    
    private func startClipboardMonitoring() {
        print("Beginning clipboard monitoring. Does this happen twice?")
        guard clipboardTimer == nil else { return }
        clipboardTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkClipboard()
        }
    }
    
    private func stopClipboardMonitoring() {
        print("Stopping clipboard monitoring")
        clipboardTimer?.invalidate()
        clipboardTimer = nil
    }
    
    private func startGarbageCollection() {
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.performCleanupInBackground()
        }
    }
    
    // cleanup untagged items after 30 days
    private func performCleanupInBackground() {
        cleanupQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Create background context for thread-safety
            let backgroundContext = ModelContext(self.context.container)
            
            do {
                let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
                
                let descriptor = FetchDescriptor<ClipboardItem>(
                    predicate: #Predicate { model in
                        model.timestamp < thirtyDaysAgo && model.tagValues.isEmpty
                    }
                )
                
                let oldModels = try backgroundContext.fetch(descriptor)
                
                for model in oldModels {
                    backgroundContext.delete(model)
                }
                
                try backgroundContext.save()
                
                // Only UI updates need main thread
                DispatchQueue.main.async {
                    print("Cleaned up \(oldModels.count) old models")
                }
                
            } catch {
                DispatchQueue.main.async {
                    print("Cleanup failed: \(error)")
                }
            }
        }
    }
    
    private func checkClipboard() {
        let currentChangeCount = pasteboard.changeCount
        
        if currentChangeCount != lastChangeCount {
            lastChangeCount = currentChangeCount
            // TODO: What about super formatted text?
            if let string = pasteboard.string(forType: .string), !string.isEmpty {
                addClipboardItem(content: string, type: .text)
            } else if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
                addClipboardItem(content: "Image", type: .image, image: image)
            }
        }
    }
    
    private func addClipboardItem(content: String, type: ClipboardItemType, image: NSImage? = nil) {
        if content != "Image" && doesItemExist(newContent: content) {
            return
        }

        let item = ClipboardItem(content: content, type: type, image: image)
        context.insert(item)
        
    }
    
    // TODO: Handle image as well
    private func doesItemExist(newContent: String) -> Bool {
        let predicate = #Predicate<ClipboardItem> { item in
            item.content == newContent
        }
        
        let descriptor = FetchDescriptor<ClipboardItem>(predicate: predicate)
        let result = try? context.fetch(descriptor)
        
        if let result = result {
            return !result.isEmpty
        }
        return false
    }
    
    // TODO: If copy, we could hash it for easiest content
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
        
        // move item to the top by setting it to current date
        item.timestamp = Date.now
        
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
        item.setTags(tags)
    }
    
//    func getAllTags() -> [String] {
//        let allTags = clipboardHistory.flatMap { $0.tags }
//        return Array(Set(allTags)).sorted()
//    }
}
