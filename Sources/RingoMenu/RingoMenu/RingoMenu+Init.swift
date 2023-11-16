//
//  RingoMenu+.swift
//
//
//  Created by Lumisilk on 2023/11/16.
//

import SwiftUI

public extension RingoMenu where Footer == EmptyView {
    init(
        isPresented: Binding<Bool>? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.explicitIsPresented = isPresented
        self.menuList = RingoMenuList(content: content)
        self.label = label()
    }
}

public extension RingoMenuList where Footer == EmptyView {
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.footer = EmptyView()
    }
}
