//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/22.
//

import Foundation

extension RandomAccessCollection {
    /// For array [1, 2, 3, 4], this method returns [(1, 2), (2, 3), (3, 4)].
    func adjacentPairs() -> AnySequence<(Element, Element)> {
        AnySequence { () -> AnyIterator<(Element, Element)> in
            var index = self.startIndex
            return AnyIterator {
                let next = self.index(after: index)
                if next < endIndex {
                    let result = (self[index], self[next])
                    index = next
                    return result
                } else {
                    return nil
                }
            }
        }
    }
}
