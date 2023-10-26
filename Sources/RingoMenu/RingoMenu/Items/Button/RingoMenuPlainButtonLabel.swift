//
//  RingoMenuPlainButton.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuPlainButtonLabel: View {
    
    @Environment(\.ringoMenuContext) private var context
    
    @ScaledMetric(relativeTo: .body) var checkmarkWidth = 18
    @ScaledMetric(relativeTo: .body) var trailingImageWidth = 30
    
    let title: String
    let image: Image?
    let attributes: RingoMenuButtonAttributes
    
    init(
        title: String,
        image: Image? = nil,
        attributes: RingoMenuButtonAttributes = []
    ) {
        self.title = title
        self.image = image
        self.attributes = attributes
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            if context.hasCheckmark {
                Group {
                    if attributes.contains(.checkmark) {
                        Image(systemName: "checkmark")
                            .font(.footnote.weight(.semibold))
                    } else {
                        Color.clear
                    }
                }
                .frame(width: checkmarkWidth)
            } else {
                Color.clear
                    .frame(width: 8)
            }
            
            
            Text(title)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if context.hasTrailingImage {
                Group {
                    if let image {
                        image
                            .frame(width: trailingImageWidth)
                    } else {
                        Color.clear
                    }
                }
                .frame(width: trailingImageWidth)
            } else {
                Color.clear
                    .frame(width: 4)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 12))
        .contentShape(Rectangle())
        .fixedSize(horizontal: false, vertical: true)
        .buttonStyle(RingoMenuButtonStyle())
        .preference(key: HasCheckmarkPreferenceKey.self, value: attributes.contains(.checkmark))
        .preference(key: HasTrailingImagePreferenceKey.self, value: image != nil)
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
    RingoMenu {
        RingoMenuPlainButtonLabel(
            title: "Title",
            image: Image(systemName: "star"),
            attributes: .checkmark
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .backport.background {
        LinearGradient(
            colors: [Color.white, Color.blue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    .ignoresSafeArea()
}
