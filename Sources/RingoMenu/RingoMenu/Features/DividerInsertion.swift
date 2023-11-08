//
//  DividerInsertion.swift
//
//
//  Created by Lumisilk on 2023/10/22.
//

import SwiftUI

enum DividerType {
    case none
    case thick
    case normal
}

enum DividerTraitKey: _ViewTraitKey {
    static var defaultValue: (before: DividerType, after: DividerType) = (.normal, .normal)
}


extension RingoMenuList {
    internal func dividersAfterChild(_ children: some RandomAccessCollection<ViewChildren.Element>) -> [ViewChildren.Element.ID: DividerType] {
        var result: [ViewChildren.Element.ID: DividerType] = [:]
        
        for (previous, next) in children.adjacentPairs() {
            let (previousAfter, nextBefore) = (previous[DividerTraitKey.self].after, next[DividerTraitKey.self].before)
            
            let dividerType: DividerType
            if previousAfter == .none || nextBefore == .none {
                dividerType = .none
            } else if previousAfter == .thick || nextBefore == .thick {
                dividerType = .thick
            } else {
                dividerType = .normal
            }
            result[previous.id] = dividerType
        }
        return result
    }
    
    internal var normalDivider: some View {
        Color.separator
            .frame(height: 1.0 / 3)
    }
}
