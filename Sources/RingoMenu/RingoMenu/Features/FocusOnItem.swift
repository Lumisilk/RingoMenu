//
//  FocusOnItem.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

/// An enum representing the transition behavior when focusing on an item in the list.
public enum RingoMenuItemFocusTransition {
    /// Shrink the list frame to the selected item with an animation.
    case animateFocusTo

    /// Make other items and background transparent.
    case transparentOthers
}

struct TransparentOtherItemTraitKey: _ViewTraitKey {
    static var defaultValue: AnyHashable? = nil
}

private struct FocusOnItemModifier: ViewModifier {
    
    @Environment(\.ringoPopoverCoordinator) private var popoverCoordinator
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    
    @State private var frame: CGRect?
    @Namespace private var id
    
    @Binding var isOn: Bool
    var transition: RingoMenuItemFocusTransition
    
    func body(content: Content) -> some View {
        content
            .backport.background {
                if transition == .animateFocusTo {
                    GeometryReader { geo in
                        let frame = geo.frame(in: .named(menuCoordinator.menuListName))
                        Color.clear
                            .onAppear { self.frame = frame }
                            .onChange(of: frame) { self.frame = $0 }
                    }
                    .hidden()
                }
            }
            .trait(
                TransparentOtherItemTraitKey.self,
                transition == .transparentOthers && isOn ? id : nil
            )
            .onChange(of: isOn, perform: update)
            .onDisappear {
                isOn = false
                update(false)
            }
    }
    
    private func update(_ isOn: Bool) {
        switch transition {
        case .animateFocusTo:
            if isOn, let frame {
                popoverCoordinator.ringoContainer?.focusOnFrame(frame)
            } else {
                popoverCoordinator.ringoContainer?.unfocus()
            }
            
        case .transparentOthers:
            menuCoordinator.transparentOtherItemID = isOn ? id : nil
            popoverCoordinator.setBackgroundHidden(isOn)
        }
    }
}

private struct HideIfNeededModifier: ViewModifier {
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    let id: AnyHashable?
    
    func body(content: Content) -> some View {
        let shouldHidden =
        if let focusID = menuCoordinator.transparentOtherItemID, focusID != id {
            true
        } else {
            false
        }
        
        content
            .opacity(shouldHidden ? 0 : 1)
    }
}

extension View {
    /// A SwiftUI View modifier that applies a focus effect on a RingoMenu's item.
    ///
    /// - Parameters:
    ///   - isOn: A binding that determines whether the focus effect is active.
    ///   - transition: The `FocusTransition` to be applied.
    public func focusOnRingoItem(isOn: Binding<Bool>, by transition: RingoMenuItemFocusTransition) -> some View {
        modifier(FocusOnItemModifier(isOn: isOn, transition: transition))
    }
    
    internal func hideIfNeeded(id: AnyHashable?) -> some View {
        modifier(HideIfNeededModifier(id: id))
    }
}

