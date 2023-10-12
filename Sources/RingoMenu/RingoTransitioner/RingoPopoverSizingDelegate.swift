//
//  RingoPopoverSizingDelegate.swift
//
//
//  Created by Lumisilk on 2023/10/12.
//

import UIKit

public protocol RingoPopoverSizingDelegate: AnyObject {
    func sizeThatFits(in size: CGSize) -> CGSize
}
