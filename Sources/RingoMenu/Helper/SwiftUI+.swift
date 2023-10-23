//
//  SwiftUI.swift
//
//
//  Created by Lumisilk on 2023/10/21.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func readSize<Value: Equatable>(of keyPath: KeyPath<CGSize, Value>, onChange: @escaping (Value) -> Void) -> some View {
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
    
    func readFrame<Value: Equatable>(of keyPath: KeyPath<CGRect, Value>, in space: CoordinateSpace, onChange: @escaping (Value) -> Void) -> some View {
        background(
            GeometryReader { geo in
                let value = geo.frame(in: space)[keyPath: keyPath]
                Color.clear
                    .onAppear { onChange(value) }
                    .onChange(of: value, perform: onChange)
            }
            .hidden()
        )
    }
}