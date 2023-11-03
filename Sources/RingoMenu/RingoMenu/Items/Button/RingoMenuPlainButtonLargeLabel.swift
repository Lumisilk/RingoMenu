//
//  RingoMenuPlainButton.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuPlainButtonLargeLabel: View {
    
    @Environment(\.ringoMenuOption) private var option
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
            if option.reserveLeadingMarkArea {
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
            
            if option.reserveTrailingImageArea {
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
        .fixedSize(horizontal: false, vertical: true)
        .buttonStyle(RingoMenuButtonStyle())
        .preference(key: HasLeadingMarkPreferenceKey.self, value: attributes.contains(.checkmark))
        .preference(key: HasTrailingImagePreferenceKey.self, value: image != nil)
    }
}

#Preview {
    VStack {
        Group {
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: "Title"
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: "Title",
                subtitle: "Subtitle"
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: String(repeating: "Title ", count: 20),
                subtitle: String(repeating: "Subtitle ", count: 20)
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: "Title",
                attributes: .checkmark
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: "Title",
                image: Image(systemName: "star")
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: "Title",
                subtitle: "Subtitle",
                image: Image(systemName: "star"),
                attributes: [.destructive, .checkmark]
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
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
    RingoMenuList {
        RingoMenuButton(
            title: String(repeating: "Title ", count: 20),
            subtitle: String(repeating: "Subtitle ", count: 20),
            image: Image(systemName: "star"),
            attributes: .checkmark,
            action: {}
        )
    }
    .backport.background {
        VisualEffectView.menuBackground
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
