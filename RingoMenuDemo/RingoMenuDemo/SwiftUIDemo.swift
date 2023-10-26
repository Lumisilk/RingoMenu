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
    @State private var isChecked = true
    
    var body: some View {
        Button("Simple RingoMenu") {
            isPresented = true
        }
        .buttonStyle(.bordered)
        .present(isPresented: $isPresented, style: .ringoPopover) {
            RingoMenu(options: .forceReserveCheckMarkArea) {
                RingoMenuButtonRow(style: .small) {
                    RingoMenuButton(title: "Title") {}
                    RingoMenuButton(title: "Title", subtitle: "Subtitle", attributes: .destructive) {}
                    RingoMenuButton(title: "Title", image: Image(systemName: "star")) {}
                }
                
                RingoMenuDivider()
                
                RingoMenuButtonRow(style: .medium) {
                    RingoMenuButton(title: "Title", attributes: .destructive) {}
                    RingoMenuButton(title: "Title", subtitle: "Subtitle") {}
                    RingoMenuButton(title: "Title", image: Image(systemName: "star"), attributes: .destructive) {}
                }
                
                RingoMenuDivider()
                
                RingoMenuButton(title: "Title") {}
                RingoMenuButton(title: "Title", subtitle: "Subtitle") {}
                RingoMenuButton(title: "Title", image: Image(systemName: "star")) {}
                
                RingoMenuDivider()
                
                RingoMenuButton(
                    title: "Checkmark",
                    attributes: isChecked ? [.checkmark, .keepsMenuPresented] : [.keepsMenuPresented],
                    action: { isChecked.toggle() }
                )
                RingoMenuButton(title: "Destructive", attributes: .destructive) {}
                RingoMenuButton(title: "KeepsMenuPresented", attributes: .keepsMenuPresented) {}
            }
        }
    }
}

#Preview {
    SimpleSwiftUIDemo()
}
