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
            RingoMenuSection {
                ForEach(0..<20) { i in
                    RingoMenuButton(title: "Some Button \(i)", action: {})
                }
            } header: {
                RingoMenuButtonRow(style: .medium) {
                    RingoMenuButton(title: "Header", image: Image(systemName: "sun.max")) {}
                    RingoMenuButton(title: "Text", image: Image(systemName: "cloud.fill")) {}
                    RingoMenuButton(title: "Button", image: Image(systemName: "snowflake")) {}
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
