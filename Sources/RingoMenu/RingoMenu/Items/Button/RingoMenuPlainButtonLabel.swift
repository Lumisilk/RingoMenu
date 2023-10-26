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
    let subtitle: String?
    let image: Image?
    let attributes: RingoMenuButtonAttributes
    
    init(
        title: String,
        subtitle: String? = nil,
        image: Image? = nil,
        attributes: RingoMenuButtonAttributes = []
    ) {
        self.title = title
        self.subtitle = subtitle
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
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                if let subtitle {
                    Text(subtitle)
                        .backport.foregroundColor(.secondary)
                }
            }
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
    VStack {
        Group {
            RingoMenu { RingoMenuPlainButtonLabel(
                title: "Title"
            )}
            
            RingoMenu { RingoMenuPlainButtonLabel(
                title: "Title",
                subtitle: "Subtitle"
            )}
            
            RingoMenu { RingoMenuPlainButtonLabel(
                title: String(repeating: "Title ", count: 20),
                subtitle: String(repeating: "Subtitle ", count: 20)
            )}
            
            RingoMenu { RingoMenuPlainButtonLabel(
                title: "Title",
                attributes: .checkmark
            )}
            
            RingoMenu { RingoMenuPlainButtonLabel(
                title: "Title",
                image: Image(systemName: "star")
            )}
            
            RingoMenu { RingoMenuPlainButtonLabel(
                title: "Title",
                subtitle: "Subtitle",
                image: Image(systemName: "star"),
                attributes: .checkmark
            )}
            
            RingoMenu { RingoMenuPlainButtonLabel(
                title: String(repeating: "Title ", count: 20),
                subtitle: String(repeating: "Subtitle ", count: 20),
                image: Image(systemName: "star"),
                attributes: .checkmark
            )}
        }
        .border(.red)
    }
}

#Preview {
    RingoMenu {
        RingoMenuButton(
            title: String(repeating: "Title ", count: 20),
            subtitle: String(repeating: "Subtitle ", count: 20),
            image: Image(systemName: "star"),
            attributes: .checkmark,
            action: {}
        )
    }
    .backport.background {
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
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
