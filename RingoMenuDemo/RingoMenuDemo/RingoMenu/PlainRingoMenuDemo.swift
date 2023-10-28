//
//  PlainRingoMenuDemo.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/24.
//

import SwiftUI
import RingoMenu

struct PlainRingoMenuDemo: View {
    
    @State private var isPresented = false
    @State private var isChecked = true
    @State private var step: Int = 100
    
    var body: some View {
        RingoMenu {
            RingoMenuButtonRow(style: .medium) {
                RingoMenuButton(title: "Title", attributes: .destructive) {}
                RingoMenuButton(title: "Title", subtitle: "Subtitle") {}
                RingoMenuButton(title: "Title", image: Image(systemName: "star"), attributes: .destructive) {}
            }
            
            RingoMenuDivider()
            
            RingoMenuButton(title: "Title") {}
            RingoMenuButton(title: "Title", subtitle: "Subtitle", image: Image(systemName: "star")) {}
            
            RingoMenuDivider()
            
            RingoMenuButton(
                title: "Checkmark",
                attributes: isChecked ? [.checkmark, .keepsMenuPresented] : [.keepsMenuPresented],
                action: { isChecked.toggle() }
            )
            RingoMenuButton(title: "Destructive", attributes: .destructive) {}
            RingoMenuButton(title: "KeepsMenuPresented", attributes: .keepsMenuPresented) {}
            
        } label: {
            Text("Plain Ringo Menu")
        }
    }
}

#Preview {
    PlainRingoMenuDemo()
}
