//
//  RingoMenuPreview.swift
//
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI

#if DEBUG
struct RingoMenuPreview: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        RingoMenu(isPresented: $isPresented) {
            RingoMenuPinnedView(position: .top) {
                RingoMenuButtonRow(style: .medium) {
                    RingoMenuButton(title: "Header", image: Image(systemName: "sun.max")) {}
                    RingoMenuButton(title: "Text", image: Image(systemName: "cloud.fill")) {}
                    RingoMenuButton(title: "Button", image: Image(systemName: "snowflake")) {}
                }
            }
            
            ForEach(0..<5) { i in
                RingoMenuButton(title: "Some Button \(i)", action: {})
            }
            
            RingoMenuPinnedView(position: .bottom) {
                RingoMenuButtonRow(style: .small) {
                    RingoMenuButton(title: "Footer") {}
                    RingoMenuButton(title: "Button") {}
                }
            }
        } label: {
            Text("Ringo Menu")
        }
    }
}

#Preview {
    RingoMenuPreview()
}
#endif
