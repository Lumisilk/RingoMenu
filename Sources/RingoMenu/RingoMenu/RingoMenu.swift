//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenu<
    Content: View,
    Header: View,
    Footer: View
>: View {
    
    @StateObject internal var coordinator = RingoMenuCoordinator()
    
    let content: Content
    let header: Header
    let footer: Footer
    
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.content = content()
        self.header = header()
        self.footer = footer()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            hideViewIfNeeded(header)
            
            AutoShrinkScrollView {
                VStack(spacing: 0) {
                    content.variadic { children in
                        let needDividerDict = needDividersAfterChild(children)
                        
                        ForEach(children) { child in
                            hideChildIfNeeded(child)
                            
                            if needDividerDict[child.id] == true {
                                hideViewIfNeeded(divider)
                            }
                        }
                    }
                }
                .environmentObject(coordinator)
            }
            
            hideViewIfNeeded(footer)
        }
        .frame(maxWidth: 300)
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
        }
        RingoMenuSectionDivider()
        ForEach(10..<20) { i in
            RingoMenuButton(title: i.description, image: Image(systemName: "star"), action: {})
        }
    } footer: {
        RingoMenuSectionDivider()
        RingoMenuButton(title: "Button", action: {})
    }
    .backport.background {
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .backport.background {
        Color.black
            .ignoresSafeArea()
    }
    .environment(\.colorScheme, .dark)
}
