//
//  EditableTagsView.swift
//  tag
//
//  Created by Miles Wilson on 6/7/25.
//

import Foundation
import SwiftUI

struct EditableTagsView: View {
    @Binding var tags: [String]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(tags, id: \.self) { tag in
                HStack(spacing: 4) {
                    Button(action: {
                        removeTag(tag)
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 12, height: 12)
                    
                    Text(tag)
                        .font(.caption)
                        .lineLimit(1)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(4)
            }
        }
    }

    
    private func removeTag(_ tag: String) {
       tags.removeAll { $0 == tag }
   }
}
