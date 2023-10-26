//
//  RingoMenu+.swift
//
//
//  Created by Lumisilk on 2023/10/22.
//

import SwiftUI

public extension RingoMenu where Header == EmptyView {
    init(options: RingoMenuOptions = [], @ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.init(options: options, content: content, header: { EmptyView() }, footer: footer)
    }
}

public extension RingoMenu where Footer == EmptyView {
    init(options: RingoMenuOptions = [], @ViewBuilder content: () -> Content, @ViewBuilder header: () -> Header) {
        self.init(options: options, content: content, header: header, footer: { EmptyView() })
    }
}

public extension RingoMenu where Header == EmptyView, Footer == EmptyView {
    init(options: RingoMenuOptions = [], @ViewBuilder content: () -> Content) {
        self.init(options: options, content: content, header: { EmptyView() }, footer: { EmptyView() })
    }
}
