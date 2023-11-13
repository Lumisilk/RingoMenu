//
//  SwiftUI.swift
//
//
//  Created by Lumisilk on 2023/10/21.
//

import SwiftUI

typealias ViewChildren = _VariadicView_Children

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func readSize<Value: Equatable>(of keyPath: KeyPath<CGSize, Value> = \.self, onChange: @escaping (Value) -> Void) -> some View {
        background(
            GeometryReader { geo in
                let value = geo.size[keyPath: keyPath]
                Color.clear
                    .onAppear { onChange(value) }
                    .onChange(of: value, perform: onChange)
            }
            .hidden()
        )
    }
    
    func readFrame<Value: Equatable>(of keyPath: KeyPath<CGRect, Value> = \.self, in space: CoordinateSpace, isEnable: Bool = true, onChange: @escaping (Value) -> Void) -> some View {
        backport.background {
            if isEnable {
                GeometryReader { geo in
                    let value = geo.frame(in: space)[keyPath: keyPath]
                    Color.clear
                        .onAppear { onChange(value) }
                        .onChange(of: value, perform: onChange)
                }
                .hidden()
            }
        }
    }
}

extension Color {
    static var separator: Color {
        Color(UIColor.separator)
    }
}

@available(iOS 16.0, *)
extension ProposedViewSize {
    var cgSize: CGSize {
        CGSize(
            width: width ?? UIView.layoutFittingExpandedSize.width,
            height: height ?? UIView.layoutFittingExpandedSize.height
        )
    }
}

// For iOS 15 and below
extension _ProposedSize {
    var cgSize: CGSize {
        var width: CGFloat = 10000
        var height: CGFloat = 10000
        for (label, value) in Mirror(reflecting: self).children {
            if label?.contains("width") == true, let value = value as? CGFloat {
                width = value
            }
            if label?.contains("height") == true, let value = value as? CGFloat {
                height = value
            }
        }
        return CGSize(width: width, height: height)
    }
}
