//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import UIKit

/// Configuration parameters utilized by `RingoPopover` to customize its behavior and presentation.
public class RingoPopoverConfiguration {
    
    /// A protocol that calculates the final frame for the popover.
    public var frameCalculator: FrameCalculator = UIMenuFrameCalculator()
    
    /// The closure executed when the popover is dismissed by gestures defined by RingoPopover.
    ///
    /// If you dismiss the presented view controller programmatically, you should call this closure yourself.
    public var onDismiss: (() -> Void)?
    
    /// The background view for the popover.
    ///
    /// By default, it uses the system's material blur effect view.
    public var backgroundView: UIView? = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    
    public init(
        frameCalculator: FrameCalculator = UIMenuFrameCalculator(),
        onDismiss: (() -> Void)? = nil,
        backgroundView: UIView? = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    ) {
        self.frameCalculator = frameCalculator
        self.onDismiss = onDismiss
        self.backgroundView = backgroundView
    }
}
