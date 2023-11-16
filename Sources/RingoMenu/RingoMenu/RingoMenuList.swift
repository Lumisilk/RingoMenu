//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuList<Content: View, Footer: View>: View {
    
    @EnvironmentObject internal var coordinator: RingoMenuCoordinator
    
    @State private var overrideReserveLeadingMarkArea = false
    @State private var overrideReserveTrailingImageArea = false
    
    let content: Content
    let footer: Footer
    
    public init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.content = content()
        self.footer = footer()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CompressedScrollView {
                content.variadic { children in
                    VStack(spacing: 0) {
                        let dividersAfterChild = dividersAfterChild(children)
                        
                        ForEach(children) { child in
                            child
                                .hideIfNeeded(id: child.id)
                                .zIndex(child[PinnedTraitKey.self] ? 1: 0)
                            
                            switch dividersAfterChild[child.id] {
                            case .normal:
                                normalDivider
                                    .hideIfNeeded(id: nil)
                                
                            case .thick:
                                RingoMenuDivider()
                                    .hideIfNeeded(id: nil)
                                
                            default:
                                EmptyView()
                            }
                        }
                    }
                }
            } isScrollableChanged: { isScrollable in
                coordinator.isHoverGestureEnable = !isScrollable
            }
            
            footer
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
