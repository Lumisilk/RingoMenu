//
//  PinnedModifier.swift
//
//
//  Created by Lumisilk on 2023/11/08.
//

import Combine
import SwiftUI

enum PinnedTraitKey: _ViewTraitKey {
    static var defaultValue = false
}

struct PinnedModifier: ViewModifier {
    
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    @Namespace private var id
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .readFrame(in: .named(menuCoordinator.menuListName)) { frame in
                menuCoordinator.headerFrames[id] = frame
            }
            .onReceive(offsetPublisher) {
                offset = $0
            }
            .trait(PinnedTraitKey.self, true)
    }
    
    private var offsetPublisher: some Publisher<CGFloat, Never> {
        menuCoordinator.$headerOffsets
            .map { $0[id] ?? 0 }
            .dropFirst()
            .removeDuplicates()
    }
}
