//
//  DividerInsertion.swift
//
//
//  Created by Lumisilk on 2023/10/22.
//

import SwiftUI

enum HideDividerTraitKey: _ViewTraitKey {
    static var defaultValue: Bool = false
}

extension RingoMenu {
    internal func needDividersAfterChild(_ children: _VariadicView_Children) -> [_VariadicView_Children.Element.ID: Bool] {
        var result: [_VariadicView_Children.Element.ID: Bool] = [:]
        for (previous, next) in children.adjacentPairs() {
            result[previous.id] = !(previous[HideDividerTraitKey.self] || next[HideDividerTraitKey.self])
        }
        return result
    }
    
    internal var divider: some View {
        VisualEffectView.divider
            .frame(height: 1.0 / 3)
    }
}
