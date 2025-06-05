//
//  ClipboardItemRow.swift
//  tag
//
//  Created by Miles Wilson on 5/27/25.
//

import Foundation
import SwiftUI

struct ClipboardItemRow: View {
    var item: ClipboardItem
    let manager: ClipboardManager
    @Binding var showingTagEditor: ClipboardItem?
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Type icon
                Image(systemName: item.type == .text ? "terminal" : "photo")
                    .foregroundColor(item.type == .text ? .green : .secondary)
                    .frame(width: 16)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    if item.type == .image {
                        HStack {
                            if let image = item.image {
                                Image(nsImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 60, maxHeight: 40)
                                    .cornerRadius(4)
                            }
                            Text("Image")
                                .font(.system(size: 12))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    } else {
                        Text(item.content)
                            .font(.system(size: 12))
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
                    }
                    
                    Text(timeAgoString(from: item.timestamp))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Actions (shown on hover)
                if isHovered {
                    HStack(spacing: 8) {
                        Button(action: { showingTagEditor = item }) {
                            Image(systemName: "tag")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .help("Edit tags")
                        
                        Button(action: { manager.copyToClipboard(item) }) {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 12))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .help("Copy to clipboard")
                        
                        Button(action: { manager.deleteItem(item) }) {
                            Image(systemName: "trash")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .help("Delete")
                    }
                }
            }
            
            // Tags
            if !item.tagValues.isEmpty {
                HStack {
                    Spacer().frame(width: 28) // Align with content
                    TagsView(tags: item.tagValues)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isHovered ? Color(NSColor.selectedControlColor).opacity(0.1) : Color.clear)
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            manager.copyToClipboard(item)
        }
        .contextMenu {
            Button("Copy to Clipboard") {
                manager.copyToClipboard(item)
            }
            Button("Edit Tags...") {
                showingTagEditor = item
            }
            Divider()
            Button("Delete") {
                manager.deleteItem(item)
            }
        }
    }
}

func timeAgoString(from date: Date) -> String {
    let interval = Date().timeIntervalSince(date)
    
    if interval < 60 {
        return "Just now"
    } else if interval < 3600 {
        let minutes = Int(interval / 60)
        return "\(minutes)m ago"
    } else if interval < 86400 {
        let hours = Int(interval / 3600)
        return "\(hours)h ago"
    } else {
        let days = Int(interval / 86400)
        return "\(days)d ago"
    }
}
