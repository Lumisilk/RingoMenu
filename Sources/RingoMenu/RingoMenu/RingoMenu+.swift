//
//  RingoMenu+.swift
//
//
//  Created by Lumisilk on 2023/10/22.
//

import SwiftUI

public extension RingoMenu where Header == EmptyView {
    init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.content = content()
        self.header = EmptyView()
        self.footer = footer()
    }
}

public extension RingoMenu where Footer == EmptyView {
    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Header) {
        self.content = content()
        self.header = header()
        self.footer = EmptyView()
    }
}

public extension RingoMenu where Header == EmptyView, Footer == EmptyView {
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = EmptyView()
        self.footer = EmptyView()
    }
}
