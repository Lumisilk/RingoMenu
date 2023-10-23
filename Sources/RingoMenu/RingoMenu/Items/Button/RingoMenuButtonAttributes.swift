//
//  RingoMenuButtonOptions.swift
//
//
//  Created by Lumisilk on 2023/10/23.
//

public struct RingoMenuButtonAttributes: OptionSet {
    public var rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public static let checkmark = RingoMenuButtonAttributes(rawValue:  1 << 0)
    public static let destructive = RingoMenuButtonAttributes(rawValue:  1 << 1)
    public static let keepsMenuPresented = RingoMenuButtonAttributes(rawValue:  1 << 2)
}
