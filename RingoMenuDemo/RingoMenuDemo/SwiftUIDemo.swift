//
//  SwiftUIDemo.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/24.
//

import SwiftUI
import RingoMenu

struct SimpleSwiftUIDemo: View {
    
    @State private var isPresented = true
    
    var body: some View {
        Button("Simple RingoMenu") {
            isPresented = true
        }
        .buttonStyle(.bordered)
        .present(isPresented: $isPresented, style: .ringoPopover) {
            RingoMenu {
                RingoMenuButton(title: "Title") {}
                RingoMenuButton(title: "Title", subtitle: "Subtitle") {}
                RingoMenuButton(title: "Title", image: Image(systemName: "star")) {}
                
                RingoMenuSectionDivider()
                
                RingoMenuButton(title: "Checkmark", attributes: .checkmark) {}
                RingoMenuButton(title: "Destructive", attributes: .destructive) {}
                RingoMenuButton(title: "KeepsMenuPresented", attributes: .keepsMenuPresented) {}
            }
        }
    }
}

#Preview {
    SimpleSwiftUIDemo()
}
