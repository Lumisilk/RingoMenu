//
//  RingoPopoverCoordinator.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public class RingoPopoverCoordinator {
    public var dismiss: () -> Void
    
    public init(dismiss: @escaping () -> Void = {}) {
        self.dismiss = dismiss
    }
}

struct RingoPopoverCoordinatorEnvironmentKey: EnvironmentKey {
    static var defaultValue = RingoPopoverCoordinator()
}

public extension EnvironmentValues {
    var ringoPopoverCoordinator: RingoPopoverCoordinator {
        get { self[RingoPopoverCoordinatorEnvironmentKey.self] }
        set { self[RingoPopoverCoordinatorEnvironmentKey.self] = newValue }
    }
}
