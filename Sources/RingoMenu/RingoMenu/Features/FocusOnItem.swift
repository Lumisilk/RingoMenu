//
//  FocusOnItem.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

/// An enum representing the behavior when focusing on an item in the list.
public enum RingoMenuItemFocusMode {

    /// Only the focused item is visible, but the position remain unchanged.
    /// Other items AND background view become transparent.
    case transparentOthers

    /// Only the focused item is visible and the list shrinks, removing other items entirely.
    case removeOthers
}

//struct FocusOnItemTraitKey: _ViewTraitKey {
//    static var defaultValue: UUID? = nil
//}

private struct FocusOnItemModifier: ViewModifier {
    
    @Environment(\.ringoPopoverCoordinator) private var popoverCoordinator
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    @State private var frame: CGRect?
    @Binding var isOn: Bool
    var mode: RingoMenuItemFocusMode
    
    func body(content: Content) -> some View {
        content
            .readFrame(in: .named(menuCoordinator.menuListName)) {
                frame = $0
            }
            .onChange(of: isOn, perform: update)
            .onDisappear {
                isOn = false
                update(false)
            }
    }
    
    private func update(_ isOn: Bool) {
        if isOn, let frame {
            popoverCoordinator.ringoContainer?.focusOnFrame(frame)
        } else {
            popoverCoordinator.ringoContainer?.unfocus()
        }
    }
}

public extension View {
    /// A SwiftUI View modifier that applies a focus effect on a RingoMenu's item.
    ///
    /// Use this modifier to either make other items in a RingoMenu transparent or to remove them entirely,
    /// allowing you to emphasize or "focus" on a specific item in the RingoMenu.
    ///
    /// - Parameters:
    ///   - isOn: A binding that determines whether the focus effect is active.
    ///   - mode: The `FocusMode` to be applied. Choose between `.transparentOthers` to make other items transparent
    ///           or `.removeOthers` to remove other items from the list entirely.
    func focusOnRingoItem(isOn: Binding<Bool>, by mode: RingoMenuItemFocusMode) -> some View {
        modifier(FocusOnItemModifier(isOn: isOn, mode: mode))
    }
}

extension RingoMenuList {
//    @ViewBuilder
//    internal func hideViewIfNeeded(_ view: some View) -> some View {
//        let shouldHidden = coordinator.focusOnItemID != nil
//        
//        switch coordinator.focusMode {
//        case .removeOthers:
//            if !shouldHidden {
//                view
//            }
//        case .transparentOthers:
//            view
//                .opacity(shouldHidden ? 0 : 1)
//        }
//    }
//    
//    @ViewBuilder
//    internal func hideChildIfNeeded(_ child: ViewChildren.Element) -> some View {
//        let shouldHidden: Bool =
//        if let focusItemID = coordinator.focusOnItemID {
//            child[FocusOnItemTraitKey.self] != focusItemID
//        } else {
//            false
//        }
//        
//        switch coordinator.focusMode {
//        case .removeOthers:
//            if !shouldHidden {
//                child
//            }
//        case .transparentOthers:
//            child
//                .opacity(shouldHidden ? 0 : 1)
//        }
//    }
}
