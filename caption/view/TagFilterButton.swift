//
//  TagFilterButton.swift
//  tag
//
//  Created by Miles Wilson on 5/27/25.
//

import Foundation
import SwiftUI

struct TagFilterButton: View {
    let tag: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(tag)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                Text("\(count)")
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isSelected ? Color.accentColor : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
