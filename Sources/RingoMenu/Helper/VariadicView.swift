//
//  VariadicView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

private struct Root<Result: View>: _VariadicView_ViewRoot {
    let childrenHandler: (_VariadicView_Children) -> Result
    
    func body(children: _VariadicView_Children) -> some View {
        childrenHandler(children)
    }
}

extension View {
    func variadic<Result: View>(
        @ViewBuilder childrenHandler: @escaping (_VariadicView_Children) -> Result
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

