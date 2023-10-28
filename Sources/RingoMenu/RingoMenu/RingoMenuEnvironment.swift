//
//  RingoMenuEnvironment.swift
//  
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI

struct RingoMenuContext {
    var embedInButtonRowStyle: RingoMenuButtonRowStyle? = nil
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


enum HasLeadingMarkPreferenceKey: PreferenceKey {
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
