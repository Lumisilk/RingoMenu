//
//  RingoMenu.swift
//
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI

public struct RingoMenu<Content: View, Footer: View, Label: View>: View {
    
    @Environment(\.ringoMenuOption) private var menuOption
    
    @StateObject internal var menuCoordinator = RingoMenuCoordinator()
    
    @State private var defaultIsPresented = false
    
    var explicitIsPresented: Binding<Bool>?
    let menuList: RingoMenuList<Content, Footer>
    let label: Label
    
    public init(
        isPresented: Binding<Bool>? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer,
        @ViewBuilder label: () -> Label
    ) {
        self.explicitIsPresented = isPresented
        self.menuList = RingoMenuList(content: content, footer: footer)
        self.label = label()
    }
    
    private var isPresented: Binding<Bool> {
        explicitIsPresented ?? $defaultIsPresented
    }
    
    public var body: some View {
        RingoMenuUIButtonBridge {
            label
        } onHover: { location in
            menuCoordinator.updateHoverGesture(location)
        } onPresent: {
            presentIfNeeded()
        } onRelease: { location in
            menuCoordinator.triggerHoverGesture(location)
        }
        .present(
            isPresented: isPresented,
            style: RingoMenuPresentationStyle(menuOption: menuOption, menuCoordinator: menuCoordinator)
        ) {
            menuList
        }
    }
    
    private func presentIfNeeded() {
        if isPresented.wrappedValue == false {
            isPresented.wrappedValue = true
        }
    }
}

#Preview {
    RingoMenuPreview()
}
