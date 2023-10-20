//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import UIKit

public class RingoPopoverConfiguration {
    
    public var frameCalculator: FrameCalculator
    
    public var onDismiss: (() -> Void)?
    
    public var backgroundView: UIView?
    
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
