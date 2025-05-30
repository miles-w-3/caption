//
//  TagsView.swift
//  tag
//
//  Created by Miles Wilson on 5/27/25.
//

import Foundation
import SwiftUI

struct TagsView: View {
    let tags: [String]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.system(size: 9))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(tagColor(for: tag))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private func tagColor(for tag: String) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red]
        let hash = abs(tag.hashValue)
        return colors[hash % colors.count]
    }
}
