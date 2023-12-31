//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/26.
//

import SwiftUI

public struct RingoMenuButtonLabel: View {
    
    @Environment(\.ringoMenuContext.embedInButtonRowStyle) var rowStyle
    
    let title: String
    let subtitle: String?
    let image: Image?
    let config: RingoMenuButtonConfiguration
    
    public var body: some View {
        Group {
            switch rowStyle {
            case .small:
                RingoMenuPlainButtonSmallLabel(title: title, image: image)
            case .medium:
                RingoMenuPlainButtonMediumLabel(title: title, image: image)
            case nil:
                RingoMenuPlainButtonLargeLabel(title: title, subtitle: subtitle, image: image, config: config)
            }
        }
        .contentShape(Rectangle())
    }
}
