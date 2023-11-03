//
//  VariadicView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

private struct Root<Result: View>: _VariadicView_ViewRoot {
    let childrenHandler: (ViewChildren) -> Result
    
    func body(children: ViewChildren) -> some View {
        childrenHandler(children)
    }
}

extension View {
    func variadic<Result: View>(
        @ViewBuilder childrenHandler: @escaping (ViewChildren) -> Result
    ) -> some View {
        _VariadicView.Tree(
            Root(childrenHandler: childrenHandler),
            content: { self }
        )
    }
    
    func trait<Key: _ViewTraitKey>(_ key: Key.Type, _ value: Key.Value) -> some View {
        self._trait(key, value)
    }
}

struct Interleave<Content: View, Separator: View>: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let separator: () -> Separator
    
    var body: some View {
        content().variadic { children in
            ForEach(children) { child in
                child
                
                if child.id != children.last?.id {
                    separator()
                }
            }
        }
    }
}
