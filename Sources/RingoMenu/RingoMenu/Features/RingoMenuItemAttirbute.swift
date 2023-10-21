//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuItemAttirbutes: OptionSet {
    public let rawValue: UInt8
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public static var keepsMenuPresented: RingoMenuItemAttirbutes { RingoMenuItemAttirbutes(rawValue:  1 << 0) }
}

private struct RingoMenuItemAttirbuteEnvironmentKey: EnvironmentKey {
    static let defaultValue: RingoMenuItemAttirbutes = []
}

public extension EnvironmentValues {
    var ringoMenuItemAttirbutes: RingoMenuItemAttirbutes {
        get { self[RingoMenuItemAttirbuteEnvironmentKey.self] }
        set { self[RingoMenuItemAttirbuteEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func ringoMenuItemAttributes(_ attributes: RingoMenuItemAttirbutes) -> some View {
        environment(\.ringoMenuItemAttirbutes, attributes)
    }
}
