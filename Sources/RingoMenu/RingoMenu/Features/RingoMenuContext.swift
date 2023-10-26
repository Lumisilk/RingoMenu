//
//  RingoMenuContext.swift
//  
//
//  Created by Lumisilk on 2023/10/23.
//

import SwiftUI

public struct RingoMenuContext {
    public var reserveCheckmarkArea = false
    public var reserveImageArea = false
    public var embedInButtonRowStyle: RingoMenuButtonRowStyle? = nil
}

private struct RingoMenuContextEnvironmentKey: EnvironmentKey {
    static let defaultValue: RingoMenuContext = RingoMenuContext()
}

extension EnvironmentValues {
    var ringoMenuContext: RingoMenuContext {
        get { self[RingoMenuContextEnvironmentKey.self] }
        set { self[RingoMenuContextEnvironmentKey.self] = newValue }
    }
}

// MARK: Children have checkmarks or images
enum HasCheckmarkPreferenceKey: PreferenceKey {
    static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

enum HasTrailingImagePreferenceKey: PreferenceKey {
    static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}
