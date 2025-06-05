//
//  TagEditorView.swift
//  tag
//
//  Created by Miles Wilson on 5/27/25.
//

import Foundation
import SwiftUI

struct TagEditorView: View {
    var item: ClipboardItem
    let manager: ClipboardManager
    @Binding var isPresented: Bool
    @State private var tagInput = ""
    @State private var currentTags: [String] = []
    
    let commonTags = ["git", "docker", "npm", "ssh", "terminal", "debug", "config", "deploy", "test", "build"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Edit Tags")
                .font(.headline)
            
            // Preview of content
            VStack(alignment: .leading, spacing: 4) {
                Text("Content:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(item.content)
                    .font(.system(size: 11))
                    .padding(8)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(4)
                    .lineLimit(3)
            }
            
            // Current tags
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Tags:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if currentTags.isEmpty {
                    Text("No tags")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    TagsView(tags: currentTags)
                }
            }
            
            // Add new tag
            VStack(alignment: .leading, spacing: 8) {
                Text("Add Tag:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    TextField("Enter tag name", text: $tagInput)
                        .onSubmit {
                            addTag()
                        }
                    
                    Button("Add") {
                        addTag()
                    }
                    .disabled(tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            
            // Common tags
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Add:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 4) {
                    ForEach(commonTags, id: \.self) { tag in
                        Button(tag) {
                            if !currentTags.contains(tag) {
                                currentTags.append(tag)
                            }
                        }
                        .disabled(currentTags.contains(tag))
                        .buttonStyle(.bordered)
                        .font(.system(size: 10))
                    }
                }
            }
            
            Spacer()
            
            // Action buttons
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                
                Spacer()
                
                Button("Clear All") {
                    currentTags.removeAll()
                }
                .foregroundColor(.red)
                
                Button("Save") {
                    manager.updateItemTags(item, tags: currentTags)
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 350, height: 400)
        .onAppear {
            
            currentTags = item.tagValues
        }
    }
    
    private func addTag() {
        let tag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !tag.isEmpty && !currentTags.contains(tag) {
            currentTags.append(tag)
            tagInput = ""
        }
    }
}
