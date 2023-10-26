//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/26.
//

import UIKit

public protocol RingoPopoverDelegate: UIViewController {
    /// This method called when the popover is dismissed by gestures defined by RingoPopover.
    ///
    /// This method won't be called if you dismiss the presented view controller programmatically,
    func ringoPopoverDidDismissed()
}
