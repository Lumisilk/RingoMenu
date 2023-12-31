//
//  RingoPopoverCoordinator.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

/// RingoPopoverCoordinator allows you to operate RingoPopover from within SwiftUI.
///
/// You can access RingoPopoverCoordinator from any child view of RingoMenu using the `ringoPopoverCoordinator` key in Environment,
/// ```
/// @Environment(\.ringoPopoverCoordinator) var popoverCoordinator
/// ```
///
/// If the view from which you access RingoPopoverCoordinator is not a descendant of RingoMenu, any methods called will have no effect.
public class RingoPopoverCoordinator {
    
    weak var ringoPresenter: RingoPresenter?
    
    var ringoContainer: RingoContainerView? {
        ringoPresenter?.ringoContainer
    }
    
    var config: RingoPopoverConfiguration? {
        ringoPresenter?.config
    }
    
    /// Dismisses the popover. Note that this method also invokes the onDismiss closure from the popover configuration.
    public func dismiss() {
        ringoPresenter?.dismissWithDelegate()
    }
    
    public func setBackgroundHidden(_ isHidden: Bool) {
        ringoContainer?.setBackgroundHidden(isHidden)
    }
}

struct RingoPopoverCoordinatorEnvironmentKey: EnvironmentKey {
    static var defaultValue = RingoPopoverCoordinator()
}

public extension EnvironmentValues {
    /// RingoPopoverCoordinator allows you to operate RingoPopover from within SwiftUI.
    ///
    /// Note that if the view from which you access RingoPopoverCoordinator is not a descendant of RingoMenu, any methods called will have no effect.
    var ringoPopoverCoordinator: RingoPopoverCoordinator {
        get { self[RingoPopoverCoordinatorEnvironmentKey.self] }
        set { self[RingoPopoverCoordinatorEnvironmentKey.self] = newValue }
    }
}
