//
//  ClipboardItem.swift
//  tag
//
//  Created by Miles Wilson on 5/27/25.
//

import Foundation
import AppKit
import SwiftData


@Model
class ClipboardItem {
    @Attribute(.unique) public var id = UUID()
    var content: String
    var type: ClipboardItemType
    var timestamp: Date
    var hasTags = false
    // Note: Need to track this for cleanup - can't query size of tags inside a predicate
    private var tags: [ItemTag]
    // Note: NSImage isn't Codable, so we store as Data
    private var imageData: Data?
    
    // Computed property to convert Data back to NSImage
    var image: NSImage? {
        guard let data = imageData else { return nil }
        return NSImage(data: data)
    }
    
    var tagValues: [String] {
        return self.tags.map{ $0.value }
    }
    
    // NOTE: This is currently used because of the underlying type difference. Changed in the future, make sure to propagate hasTags tracker
    func setTags(_ tags: [String]) {
        self.tags = tags.map{ ItemTag(value: $0) }
        self.hasTags = !self.tags.isEmpty
    }
    
    init(content: String, type: ClipboardItemType, image: NSImage? = nil, tags: [String] = []) {
        self.content = content
        self.type = type
        self.timestamp = Date()
        self.tags = tags.map{ ItemTag(value: $0) }
        // Convert NSImage to Data for storage
        self.imageData = image?.tiffRepresentation
    }
}

enum ClipboardItemType: Codable {
    case text
    case image
}

struct ItemTag: Codable {
    let value: String
}
