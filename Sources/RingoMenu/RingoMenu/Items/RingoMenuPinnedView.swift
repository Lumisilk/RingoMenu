//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/29.
//

import SwiftUI

private enum RingoMenuPinnedTraitKey: _ViewTraitKey {
    static var defaultValue: RingoMenuPinnedPosition? = nil
}

public enum RingoMenuPinnedPosition {
    case top
    case bottom
}

public struct RingoMenuPinnedView<Content: View>: View {
    let position: RingoMenuPinnedPosition
    let addDivider: Bool
    let content: Content
    
    public init(position: RingoMenuPinnedPosition, addDivider: Bool = true, @ViewBuilder content: () -> Content) {
        self.position = position
        self.addDivider = addDivider
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if position == .bottom && addDivider {
                RingoMenuDivider()
            }
            
            content
            
            if position == .top && addDivider {
                RingoMenuDivider()
            }
        }
        .trait(RingoMenuPinnedTraitKey.self, position)
    }
}

extension RingoMenuList {
    internal func separatePinnedView(_ children: _VariadicView_Children) -> (
        top: _VariadicView_Children.Element?,
        bottom: _VariadicView_Children.Element?,
        notPinnedChildren: [_VariadicView_Children.Element]
    ) {
        var top: _VariadicView_Children.Element?
        var bottom: _VariadicView_Children.Element?
        var notPinnedChildren: [_VariadicView_Children.Element] = []
        
        for child in children {
            switch child[RingoMenuPinnedTraitKey.self] {
            case .top:
                top = child
            case .bottom:
                bottom = child
            case .none:
                notPinnedChildren.append(child)
            }
        }
        return (top, bottom, notPinnedChildren)
    }
}
