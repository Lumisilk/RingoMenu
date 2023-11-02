//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI

public struct RingoMenu<Content: View, Label: View>: View {
    
    @Environment(\.ringoMenuOption) private var ringoMenuOption
    
    @StateObject internal var coordinator = RingoMenuCoordinator()
    
    @State private var internalIsPresented: Bool = false
    
    var explicitIsPresented: Binding<Bool>?
    let menuList: RingoMenuList<Content>
    let label: Label
    
    public init(
        isPresented: Binding<Bool>? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.explicitIsPresented = isPresented
        self.menuList = RingoMenuList(content: content)
        self.label = label()
    }
    
    private var isPresented: Binding<Bool> {
        explicitIsPresented ?? $internalIsPresented
    }
    
    public var body: some View {
        Button {
            presentIfNeeded()
        } label: {
            label
        }
        .present(isPresented: isPresented, style: RingoMenuPresentationStyle()) {
            menuList
                .environment(\.ringoMenuOption, ringoMenuOption)
                .environmentObject(coordinator)
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
