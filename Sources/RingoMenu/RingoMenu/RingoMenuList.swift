//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuList<Content: View>: View {
    
    @EnvironmentObject internal var coordinator: RingoMenuCoordinator
    
    @State private var overrideReserveLeadingMarkArea = false
    @State private var overrideReserveTrailingImageArea = false
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            content.variadic { children in
                let (top, bottom, notPinnedChildren) = separatePinnedView(children)
                
//                hideViewIfNeeded(top)
                top
                
                CompressedScrollView {
                    VStack(spacing: 0) {
                        let needDividersAfterChild = needDividersAfterChild(notPinnedChildren)
                        ForEach(notPinnedChildren) { child in
//                            hideChildIfNeeded(child)
                            child
                            
                            if needDividersAfterChild[child.id] == true {
//                                hideViewIfNeeded(divider)
                                divider
                            }
                        }
                    }
                } isScrollableChanged: {
                    coordinator.isHoverGestureEnable = !$0
                }
                
//                hideViewIfNeeded(bottom)
                bottom
            }
        }
        .frame(maxWidth: 250)
        .coordinateSpace(name: coordinator.menuListName)
        .onPreferenceChange(HasLeadingMarkPreferenceKey.self) {
            if $0 { overrideReserveLeadingMarkArea = true }
        }
        .onPreferenceChange(HasTrailingImagePreferenceKey.self) {
            if $0 { overrideReserveTrailingImageArea = true }
        }
        .transformEnvironment(\.ringoMenuOption) { option in
            if overrideReserveLeadingMarkArea {
                option.reserveLeadingMarkArea = true
            }
            if overrideReserveTrailingImageArea {
                option.reserveTrailingImageArea = true
            }
        }
    }
}

#Preview {
    RingoMenuPreview()
}
