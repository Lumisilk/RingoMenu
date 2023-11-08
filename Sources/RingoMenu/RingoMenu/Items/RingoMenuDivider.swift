//
//  RingoMenuSectionDivider.swift
//
//
//  Created by Lumisilk on 2023/10/22.
//

import SwiftUI

/// A separator with a height of 8.
///
/// RingoMenu will not display dividers above and below a RingoMenuDivider.
public struct RingoMenuDivider: View {
    @Environment(\.colorScheme) private var colorSceme
    
    public init() {}
    
    public var body: some View {
        Color(
            UIColor(
                white: 0,
                alpha: colorSceme == .light ? 0.08 : 0.16
            )
        )
        .frame(height: 8)
        .trait(DividerTraitKey.self, (.none, .none))
    }
}
