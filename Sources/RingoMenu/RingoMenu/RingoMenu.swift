//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI

public struct RingoMenu<Content: View, Label: View>: View {
    
    @Environment(\.ringoMenuOption) private var ringoMenuOption
    
    @State private var internalIsPresented: Bool
    
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
        _internalIsPresented = .init(initialValue: false)
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
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded { successed in
                    if successed {
                        presentIfNeeded()
                    }
                }
        )
        .present(isPresented: isPresented, style: .ringoPopover) {
            menuList
                .environment(\.ringoMenuOption, ringoMenuOption)
        }
    }
    
    private func presentIfNeeded() {
        if !isPresented.wrappedValue {
            isPresented.wrappedValue = true
        }
    }
}

#Preview {
    RingoMenuPreview()
}
