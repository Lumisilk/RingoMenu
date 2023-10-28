//
//  RingoMenuPreview.swift
//
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI

#if DEBUG
struct RingoMenuPreview: View {
    
    @State var isPresented: Bool = true
    
    var body: some View {
        RingoMenu(isPresented: $isPresented) {
            RingoMenuButtonRow(style: .medium) {
                RingoMenuButton(title: "Sun", image: Image(systemName: "sun.max")) {}
                RingoMenuButton(title: "Cloud", image: Image(systemName: "cloud.fill")) {}
                RingoMenuButton(title: "Snow", image: Image(systemName: "snowflake")) {}
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
