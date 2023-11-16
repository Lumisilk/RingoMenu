//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuList<Content: View, Footer: View>: View {
    
    @EnvironmentObject internal var coordinator: RingoMenuCoordinator
    @ScaledMetric(relativeTo: .body) private var leadingMarkWidth = 18
    @ScaledMetric(relativeTo: .body) private var trailingImageWidth = 30
    
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
                                .hideIfNeeded(child: child)
                                .zIndex(child[PinnedTraitKey.self] ? 1 : 0)
//                            
                            switch dividersAfterChild[child.id] {
                            case .normal:
                                normalDivider
                                    .hideIfNeeded(child: nil)
                                
                            case .thick:
                                RingoMenuDivider()
                                    .hideIfNeeded(child: nil)
                                
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
            if $0 {
                coordinator.reserveLeadingMarkArea = true
                coordinator.leadingMarkWidth = leadingMarkWidth
            }
        }
        .onPreferenceChange(HasTrailingImagePreferenceKey.self) {
            if $0 {
                coordinator.reserveTrailingImageArea = true
                coordinator.trailingImageWidth = trailingImageWidth
            }
        }
        .transformEnvironment(\.ringoMenuOption) { option in
            if coordinator.reserveLeadingMarkArea {
                option.reserveLeadingMarkArea = true
            }
            if coordinator.reserveTrailingImageArea {
                option.reserveTrailingImageArea = true
            }
        }
    }
}

#Preview {
    RingoMenuPreview()
}
