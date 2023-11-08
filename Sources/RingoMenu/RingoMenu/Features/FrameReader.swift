//
//  FrameReader.swift
//
//
//  Created by Lumisilk on 2023/11/08.
//

import SwiftUI

struct FrameReaderModifier: ViewModifier {
    
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    
    let child: ViewChildren.Element
    
    func body(content: Content) -> some View {
        content
            .backport.background {
                if observesGlobalFrame || observeHeaderFrame {
                    GeometryReader { proxy in
                        Color.clear
                            .observe(isEnable: observesGlobalFrame, value: proxy.frame(in: .global)) {
                                menuCoordinator.childrenGlobalFrame[child.id] = $0
                            }
                            .observe(isEnable: observeHeaderFrame, value: proxy.frame(in: .named(menuCoordinator.menuListName))) {
                                menuCoordinator.headerFrames[child.id] = $0
                            }
                    }
                    .hidden()
                }
            }
    }
    
    private var observesGlobalFrame: Bool {
        menuCoordinator.isHoverGestureEnable
    }
    
    private var observeHeaderFrame: Bool {
        child[IsHeaderTraitKey.self]
    }
}

extension View {
    @ViewBuilder
    fileprivate func observe<Value: Equatable>(isEnable: Bool, value: @autoclosure () -> Value, changeHandler: @escaping (Value) -> Void) -> some View {
        if isEnable {
            let value = value()
            self
                .onAppear { changeHandler(value) }
                .onChange(of: value, perform: changeHandler)
        } else {
            self
        }
    }
    
    func frameReader(child: ViewChildren.Element) -> some View {
        modifier(FrameReaderModifier(child: child))
    }
}

