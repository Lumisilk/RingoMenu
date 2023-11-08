//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/22.
//

import Foundation

extension RandomAccessCollection {
    /// For array [1, 2, 3, 4], this method returns [(1, 2), (2, 3), (3, 4)].
    func adjacentPairs() -> some Sequence<(Element, Element)> {
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
    
    /// For array [1, 2, 3, 4], this method returns [(nil, 1), (1, 2), (2, 3), (3, 4)].
    func adjacentPairsFromNil() -> some Sequence<(previous: Element?, current: Element)> {
        sequence(state: (previous: nil as Element?, iterator: makeIterator())) { state in
            guard let next = state.iterator.next() else { return nil }
            defer { state.previous = next }
            return (state.previous, next)
        }
    }
}
