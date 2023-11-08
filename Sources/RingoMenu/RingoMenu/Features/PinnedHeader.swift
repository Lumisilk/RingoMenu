//
//  PinnedHeader.swift
//
//
//  Created by Lumisilk on 2023/11/08.
//

import Combine
import SwiftUI

enum IsHeaderTraitKey: _ViewTraitKey {
    static var defaultValue: Bool = false
}

struct PinnedIfNeededModifier: ViewModifier {
    
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    
    @State private var offset: CGFloat = 0

    let id: AnyHashable

    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .onReceive(offsetPublisher) {
                offset = $0
            }
            .zIndex(1)
    }
    
    private var offsetPublisher: some Publisher<CGFloat, Never> {
        menuCoordinator.$headerOffsets
            .map { $0[id] ?? 0 }
            .dropFirst()
            .removeDuplicates()
    }
}

extension View {
    @ViewBuilder
    func pinnedIfNeeded(child: ViewChildren.Element) -> some View {
        if child[IsHeaderTraitKey.self] {
            modifier(PinnedIfNeededModifier(id: child.id))
        } else {
            self
        }
    }
}
