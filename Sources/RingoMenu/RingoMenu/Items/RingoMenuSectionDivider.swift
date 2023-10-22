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
struct RingoMenuSectionDivider: View {
    @Environment(\.colorScheme) var colorSceme
    
    var body: some View {
        Color(
            UIColor(
                white: 0,
                alpha: colorSceme == .light ? 0.08 : 0.16
            )
        )
        .frame(height: 8)
        .trait(HideDividerTraitKey.self, true)
    }
}
