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

extension RingoMenuList {
    internal func needDividersAfterChild(_ children: some RandomAccessCollection<ViewChildren.Element>) -> [ViewChildren.Element.ID: Bool] {
        var result: [ViewChildren.Element.ID: Bool] = [:]
        for (previous, next) in children.adjacentPairs() {
            result[previous.id] = !(previous[HideDividerTraitKey.self] || next[HideDividerTraitKey.self])
        }
        return result
    }
    
    internal var divider: some View {
        Color.separator
            .frame(height: 1.0 / 3)
    }
}
