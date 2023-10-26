//
//  RingoMenuButtonRow.swift
//  
//
//  Created by Lumisilk on 2023/10/26.
//

import SwiftUI

public enum RingoMenuButtonRowStyle {
    case small
    case medium
}

public struct RingoMenuButtonRow<Content: View>: View {
    
    let style: RingoMenuButtonRowStyle
    let content: Content
    
    public init(style: RingoMenuButtonRowStyle, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Interleave {
                content
            } separator: {
                VisualEffectView.divider
                    .frame(width: 1.0 / 3)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .transformEnvironment(\.ringoMenuContext.embedInButtonRowStyle) { style in
            style = self.style
        }
    }
}

#Preview {
    RingoMenuButtonRow(style: .small) {
        RingoMenuButton(title: "Title", action: {})
        RingoMenuButton(title: "Title", image: Image(systemName: "star"), action: {})
    }
}
