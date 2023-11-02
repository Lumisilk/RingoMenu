//
//  RingoMenuOption.swift
//  
//
//  Created by Lumisilk on 2023/10/23.
//

import SwiftUI

public struct RingoMenuOption {
    public var reserveLeadingMarkArea = false
    public var reserveTrailingImageArea = false
    
    public var backgroundView: AnyView?
    public var highlightedView: AnyView? = VisualEffectView.highlightedBackground.eraseToAnyView()
    
    public init(
        reserveLeadingMarkArea: Bool = false,
        reserveTrailingImageArea: Bool = false,
        backgroundView: AnyView? = nil,
        highlightedView: AnyView? = nil
    ) {
        self.reserveLeadingMarkArea = reserveLeadingMarkArea
        self.reserveTrailingImageArea = reserveTrailingImageArea
        self.backgroundView = backgroundView
        self.highlightedView = highlightedView
    }
}

public struct RingoMenuOptionKey: EnvironmentKey {
    public static let defaultValue: RingoMenuOption = RingoMenuOption()
}

extension EnvironmentValues {
    var ringoMenuOption: RingoMenuOption {
        get { self[RingoMenuOptionKey.self] }
        set { self[RingoMenuOptionKey.self] = newValue }
    }
}

public extension View {
    func ringoMenuOption<Value>(_ keyPath: WritableKeyPath<RingoMenuOption, Value>, _ value: Value) -> some View {
        environment((\EnvironmentValues.ringoMenuOption).appending(path: keyPath), value)
    }
}
