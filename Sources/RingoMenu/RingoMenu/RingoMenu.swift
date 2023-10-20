//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenu<Content: View>: View {
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        AutoShrinkScrollView {
            VStack(spacing: 0) {
                content
            }
        }
    }
}

#Preview {
    RingoMenu {
        ForEach(0..<10) { i in
            RingoMenuButton(title: i.description, image: Image(systemName: "star"), action: {})
                .disabled(i.isMultiple(of: 2))
            Divider()
        }
    }
}
