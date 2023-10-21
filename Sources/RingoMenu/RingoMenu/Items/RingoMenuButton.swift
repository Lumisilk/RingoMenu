//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuButton: View {
    
    @Environment(\.ringoPopoverCoordinator) private var popoverCoordinator
    @Environment(\.ringoMenuItemAttirbutes) private var attributes
    
    let title: String
    let image: Image?
    let action: () -> Void
    
    public init(title: String, image: Image? = nil, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
            if !attributes.contains(.keepsMenuPresented) {
                popoverCoordinator.dismiss()
            }
        } label: {
            content
        }
        .buttonStyle(RingoMenuButtonStyle())
    }
    
    private var content: some View {
        HStack {
            Text(title)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            image
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}

struct RingoMenuButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            if #available(iOS 15, *) {
                configuration.label
                    .background { background(highlighted: configuration.isPressed) }
                    .foregroundStyle(isEnabled ? .primary : .secondary)
            } else {
                configuration.label
                    .background(background(highlighted: configuration.isPressed))
                    .foregroundColor(isEnabled ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func background(highlighted: Bool) -> some View {
        if highlighted {
            VisualEffectView(
                effect: UIVibrancyEffect(
                    blurEffect: UIBlurEffect(style: .systemMaterial),
                    style: UIVibrancyEffectStyle.tertiaryFill
                ),
                backgroundColor: UIColor.white
            )
        }
    }
}

#Preview {
    if #available(iOS 15.0, *) {
        RingoMenuButton(title: "Title", image: Image(systemName: "star"), action: {})
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                LinearGradient(
                    colors: [Color.green, Color.blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .ignoresSafeArea()
    } else {
        EmptyView()
    }
}
