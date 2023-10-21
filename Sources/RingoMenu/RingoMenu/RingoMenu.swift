//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenu<Content: View>: View {
    
    @StateObject private var coordinator = RingoMenuCoordinator()
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        AutoShrinkScrollView {
            VStack(spacing: 0) {
                content.variadic { children in
                    ForEach(children) { child in
                        hideChildIfNeeded(child)
                    }
                }
            }
            .environmentObject(coordinator)
        }
        .frame(maxWidth: 300)
    }
    
    @ViewBuilder
    func hideChildIfNeeded(_ child: _VariadicView_Children.Element) -> some View {
        let shouldHidden: Bool =
        if let focusItemID = coordinator.focusOnItemID {
            child[FocusOnItemTraitKey.self] != focusItemID
        } else {
            false
        }
        
        switch coordinator.focusMode {
        case .removeOthers:
            if !shouldHidden {
                child
            }
        case .transparentOthers:
            child
                .opacity(shouldHidden ? 0 : 1)
        }
    }
}

#Preview {
    RingoMenu {
        RingoMenuStepper(
            value: .constant(100),
            bounds: 50...150,
            step: 10,
            contentText: { "\($0.description)%" },
            decrementText: "あ",
            incrementText: "あ"
        )
        
        ForEach(0..<10) { i in
            RingoMenuButton(title: i.description, image: Image(systemName: "star"), action: {})
            Divider()
        }
    }
}
