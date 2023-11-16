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
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    
    let title: String
    var subtitle: String?
    var image: Image?
    var config = RingoMenuButtonConfiguration()
    
    public var body: some View {
        HStack(spacing: 4) {
            if option.reserveLeadingMarkArea {
                Group {
                    if let imageName = config.leadingMark?.systemImageName {
                        Image(systemName: imageName)
                            .font(.footnote.weight(.semibold))
                    } else {
                        Color.clear
                    }
                }
                .frame(width: menuCoordinator.leadingMarkWidth)
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
                    } else {
                        Color.clear
                    }
                }
                .frame(width: menuCoordinator.trailingImageWidth)
            } else {
                Color.clear
                    .frame(width: 4)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 12))
        .fixedSize(horizontal: false, vertical: true)
        .preference(key: HasLeadingMarkPreferenceKey.self, value: config.leadingMark != nil)
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
                config: .init(leadingMark: .checkmark)
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: "Title",
                image: Image(systemName: "star")
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: "Title",
                subtitle: "Subtitle",
                image: Image(systemName: "star"),
                config: .init(leadingMark: .checkmark, isDestructive: true)
            )}
            
            RingoMenuList { RingoMenuPlainButtonLargeLabel(
                title: String(repeating: "Title ", count: 20),
                subtitle: String(repeating: "Subtitle ", count: 20),
                image: Image(systemName: "star"),
                config: .init(leadingMark: .checkmark)
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
            config: .init(leadingMark: .checkmark),
            action: {}
        )
    }
    .backport.background {
        VisualEffectView.menuBackground()
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
