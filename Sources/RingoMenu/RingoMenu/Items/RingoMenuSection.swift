//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/29.
//

import SwiftUI

public struct RingoMenuSection<Content: View, Header: View>: View {

    let content: Content
    let header: Header
    
    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Header) {
        self.content = content()
        self.header = header()
    }
    
    public var body: some View {
        header
            .trait(IsHeaderTraitKey.self, true)
            .trait(DividerTraitKey.self, (.thick, .none))
        
        content.variadic { children in
            ForEach(children) { child in
                child
                    .trait(DividerTraitKey.self, (.normal, child.id == children.last?.id ? .thick : .normal))
            }
        }
    }
}

public struct RingoMenuSectionTextHeader: View {
    let title: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .backport.foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Color.separator
                .frame(height: 1 / 3)
        }
    }
}

public extension RingoMenuSection where Header == RingoMenuSectionTextHeader {
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = RingoMenuSectionTextHeader(title: title)
    }
}