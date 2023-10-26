//
//  CompressedScrollView.swift
//
//
//  Created by Lumisilk on 2023/10/26.
//

import SwiftUI

struct CompressedScrollView<Content: View>: View {
    @State private var scrollViewHeight: CGFloat?
    @State private var contentHeight: CGFloat?
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16, *) {
            ScrollView {
                content
                    .readSize(of: \.height) { contentHeight = $0 }
            }
            .frame(maxHeight: contentHeight, alignment: .top)
            .readSize(of: \.height) { scrollViewHeight = $0 }
            .scrollDisabled(scrollDisabled)
        } else {
            ScrollView(scrollDisabled ? [] : .vertical) {
                content
                    .readSize(of: \.height) { contentHeight = $0 }
            }
            .frame(maxHeight: contentHeight, alignment: .top)
            .readSize(of: \.height) { scrollViewHeight = $0 }
        }
    }
    
    private var scrollDisabled: Bool {
        if let scrollViewHeight, let contentHeight {
            scrollViewHeight >= contentHeight
        } else {
            false
        }
    }
}

struct CompressedScrollViewScrollView_Preview: PreviewProvider {
    struct Example: View {
        @State private var count = 10
        
        var body: some View {
            VStack {
                CompressedScrollView {
                    VStack {
//                        Color.blue
                        ForEach(Array(0..<count), id: \.self) { i in
                            Text("\(i) " + String(repeating: "Title ", count: i))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                                .lineLimit(nil)
                        }
                    }
                    .border(.green)
                }
                .border(.red)
                .frame(maxHeight: .infinity)
                
                Stepper("Row", value: $count, in: 1...20)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        Example()
    }
}
