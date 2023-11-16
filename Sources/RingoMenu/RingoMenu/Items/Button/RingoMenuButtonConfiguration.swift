//
//  RingoMenuButtonConfiguration.swift
//
//
//  Created by Lumisilk on 2023/10/23.
//

public enum RingoMenuButtonLeadingMark {
    case checkmark
    case mixedCheck
    case closure
    
    var systemImageName: String {
        switch self {
        case .checkmark:
            "checkmark"
        case .mixedCheck:
            "minus"
        case .closure:
            "chevron.forward"
        }
    }
}

public struct RingoMenuButtonConfiguration {
    
    public var leadingMark: RingoMenuButtonLeadingMark?
    
    public var isDestructive = false
    
    public var keepsMenuPresented = false
    
    public init(
        leadingMark: RingoMenuButtonLeadingMark? = nil,
        isDestructive: Bool = false,
        keepsMenuPresented: Bool = false
    ) {
        self.leadingMark = leadingMark
        self.isDestructive = isDestructive
        self.keepsMenuPresented = keepsMenuPresented
    }
}

public extension RingoMenuButtonConfiguration {
    static var destructive: RingoMenuButtonConfiguration {
        RingoMenuButtonConfiguration(isDestructive: true)
    }
    
    static var keepsMenuPresented: RingoMenuButtonConfiguration {
        RingoMenuButtonConfiguration(keepsMenuPresented: true)
    }
}
