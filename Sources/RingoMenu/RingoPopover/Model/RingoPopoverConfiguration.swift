//
//  RingoPopoverConfiguration.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import UIKit

/// Configuration parameters utilized by `RingoPopover` to customize its behavior and presentation.
public struct RingoPopoverConfiguration {
    
    /// The background view for the popover.
    ///
    /// By default, it uses the system's material blur effect view.
    public var backgroundView: UIView?
    
    /// A protocol that calculates the final frame for the popover.
    public var frameCalculator: FrameCalculator
    
    public init(
        backgroundView: UIView? = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial)),
        frameCalculator: FrameCalculator = UIMenuFrameCalculator()
    ) {
        self.backgroundView = backgroundView
        self.frameCalculator = frameCalculator
    }
}
