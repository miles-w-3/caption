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
    let content: String
    let type: ClipboardItemType
    let timestamp: Date
    var tags: [String] = []
    // Note: NSImage isn't Codable, so we store as Data
    private let imageData: Data?
    
    // Computed property to convert Data back to NSImage
    var image: NSImage? {
        guard let data = imageData else { return nil }
        return NSImage(data: data)
    }
    
    init(content: String, type: ClipboardItemType, image: NSImage? = nil, tags: [String] = []) {
        self.content = content
        self.type = type
        self.timestamp = Date()
        self.tags = tags
        // Convert NSImage to Data for storage
        self.imageData = image?.tiffRepresentation
    }
    
}

enum ClipboardItemType: Codable {
    case text
    case image
}
