//
//  ClipboardView.swift
//  tag
//
//  Created by Miles Wilson on 5/27/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ClipboardView: View {
    // TODO: I think needed for clipboard management operations
    var manager: ClipboardManager
    
    @Query(sort: \ClipboardItem.timestamp, order: .reverse)
    var clipboardHistory: [ClipboardItem]
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State private var selectedTags: Set<String> = []
    @State private var showingTagEditor: ClipboardItem?
    
    func getAllTags() -> [String] {
        let allTags = clipboardHistory.flatMap { $0.tags }
        return Array(Set(allTags)).sorted()
    }
    
    var allTags: [String] {
        getAllTags()
    }
    
    var filteredItems: [ClipboardItem] {
        var items = clipboardHistory
        
        // Filter by selected tags
        if !selectedTags.isEmpty {
            items = items.filter { item in
                selectedTags.allSatisfy { tag in
                    item.tags.contains(tag)
                }
            }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            items = items.filter {
                $0.content.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return items
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Tags Sidebar
            VStack(alignment: .leading, spacing: 8) {
                Text("Tags")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                
                if allTags.isEmpty {
                    Text("No tags yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            // "All" tag
                            TagFilterButton(
                                tag: "All",
                                isSelected: selectedTags.isEmpty,
                                count: clipboardHistory.count
                            ) {
                                selectedTags.removeAll()
                            }
                            
                            ForEach(allTags, id: \.self) { tag in
                                TagFilterButton(
                                    tag: tag,
                                    isSelected: selectedTags.contains(tag),
                                    count: clipboardHistory.filter { $0.tags.contains(tag) }.count
                                ) {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
                
                Spacer()
            }
            .frame(width: 150)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Main Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Clipboard Manager")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: manager.clearHistory) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("Clear History")
                }
                .padding()
                .background(Color(NSColor.windowBackgroundColor))
                
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search clipboard or tags...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(NSColor.windowBackgroundColor))
                
                Divider()
                
                // Clipboard items
                if filteredItems.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "doc.on.clipboard")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text(getEmptyStateMessage())
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 1) {
                            ForEach(filteredItems) { item in
                                ClipboardItemRow(item: item, manager: manager, showingTagEditor: $showingTagEditor)
                            }
                        }
                    }
                }
            }
        }
        .frame(width: 600, height: 500)
        .sheet(item: $showingTagEditor) { item in
            TagEditorView(item: item, manager: manager, isPresented: .init(
                get: { showingTagEditor != nil },
                set: { if !$0 { showingTagEditor = nil } }
            ))
        }
    }
    
    private func getEmptyStateMessage() -> String {
        if !selectedTags.isEmpty {
            return "No items with selected tags"
        } else if !searchText.isEmpty {
            return "No matching items"
        } else {
            return "No clipboard history"
        }
    }
}
