//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct CompressedScrollView<Content: View>: View {
    @State private var contentHeight: CGFloat?
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ScrollView {
            content
                .readSize(of: \.height) {
                    print("contentHeight: ", $0)
                    contentHeight = $0
                }
        }
        .frame(maxHeight: contentHeight, alignment: .top)
    }
}

public struct RingoMenu<
    Content: View,
    Header: View,
    Footer: View
>: View {
    
    @StateObject internal var coordinator = RingoMenuCoordinator()
    @State private var context = RingoMenuContext()
    
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
            
            CompressedScrollView {
//            AutoShrinkScrollView {
                VStack(spacing: 0) {
                    content.variadic { children in
                        let needDividersAfterChild = needDividersAfterChild(children)
                        
                        ForEach(children) { child in
                            hideChildIfNeeded(child)
                            
                            if needDividersAfterChild[child.id] == true {
                                hideViewIfNeeded(divider)
                            }
                        }
                    }
                }
                .environmentObject(coordinator)
            }
            .border(.red)
            
            hideViewIfNeeded(footer)
        }
        .frame(maxWidth: 250)
        .onPreferenceChange(HasCheckmarkPreferenceKey.self) {
            if $0 { context.hasCheckmark = true }
        }
        .onPreferenceChange(HasTrailingImagePreferenceKey.self) {
            if $0 { context.hasTrailingImage = true }
        }
        .environment(\.ringoMenuContext, context)
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
        
        RingoMenuButton(title: "Title", action: {})
        RingoMenuButton(title: "Title", attributes: .checkmark, action: {})
        
        ForEach(5..<10) { i in
            RingoMenuButton(title: String(repeating: "Long", count: i), image: Image(systemName: "house.fill"), action: {})
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
