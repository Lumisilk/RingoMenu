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
        RingoMenu(isPresented: $isPresented) {
            RingoMenuButtonRow(style: .medium) {
                RingoMenuButton(title: "Title", config: .init(isDestructive: true)) {}
                RingoMenuButton(title: "Title", subtitle: "Subtitle") {}
                RingoMenuButton(title: "Title", image: Image(systemName: "star"), config: .destructive) {}
            }
            
            RingoMenuDivider()
            
            RingoMenuButton(title: "Title") {}
            RingoMenuButton(title: "Title", subtitle: "Subtitle", image: Image(systemName: "star")) {}
            
            RingoMenuDivider()
            
            RingoMenuButton(
                title: "Checkmark",
                config: .init(leadingMark: isChecked ? .checkmark : nil, keepsMenuPresented: true),
                action: { isChecked.toggle() }
            )
            RingoMenuButton(title: "Destructive", config: .destructive) {}
            RingoMenuButton(title: "KeepsMenuPresented", config: .keepsMenuPresented) {}
            
            ForEach(0..<5) { _ in
                RingoMenuSection("Header") {
                    ForEach(0..<5) { i in
                        RingoMenuButton(title: "Some Button \(i)", action: {})
                    }
                }
            }
        } footer: {
            Divider()
            RingoMenuButtonRow(style: .small) {
                RingoMenuButton(title: "Footer 1", action: {})
                RingoMenuButton(title: "Footer 2", action: {})
            }
        } label: {
            Text("Plain Ringo Menu")
        }
        .ringoMenuOption(\.self,
            RingoMenuOption(
                backgroundView: AnyView(Color(.secondarySystemBackground)),
                highlightedView: AnyView(Color(.systemGray3)),
                onDismiss: { print("RingoMenu dismissed.") }
            )
        )
    }
}

#Preview {
    PlainRingoMenuDemo()
}
