//
//  FontSizeStepper.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI
import RingoMenu

struct FontSizeStepper: View {
    
    let step = 10
    let bounds = 50...200
    let defaultSize = 100
    
    @State private var isFocused = false
    
    @Binding var size: Int
    
    var body: some View {
        RingoMenuButtonRow(style: .small) {
            RingoMenuButton(config: .keepsMenuPresented) {
                size = max(bounds.lowerBound, size - step)
                isFocused = true
            } label: {
                Text("A")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            .disabled(size <= bounds.lowerBound)
            
            RingoMenuButton(title: "\(size)%", config: .keepsMenuPresented) {
                size = defaultSize
                isFocused = false
            }
            .disabled(size == defaultSize)
            
            RingoMenuButton(config: .keepsMenuPresented) {
                size = min(bounds.upperBound, size + step)
                isFocused = true
            } label: {
                Text("A")
                    .font(.body)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            .disabled(size <= bounds.lowerBound)
        }
        .focusOnRingoItem(isOn: $isFocused, by: .animateFocusTo)
    }
}

struct FontSizeStepperDemo: View {
    @State private var text = ""
    @State private var sizeRatio: Int = 100
    
    var body: some View {
        VStack {
            ScrollView {
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                    .font(.system(size: 17.0 * CGFloat(sizeRatio) / 100))
                    .padding(.horizontal)
            }
            
            RingoMenu {
                ForEach(1..<6) { i in
                    RingoMenuButton(title: "Add \(i*4)-length text to source button", config: .keepsMenuPresented) {
                        text = String(repeating: "AAAA", count: i)
                    }
                }
                FontSizeStepper(size: $sizeRatio)
            } label: {
                Text("FontSizeStepper Example " + text)
                    .padding()
                    .background {
                        Color(.secondarySystemBackground)
                    }
                    .animation(.default, value: text)
            }
        }
    }
}

#Preview {
    FontSizeStepperDemo()
}
