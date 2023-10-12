//
//  Helper.swift
//
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width  + rhs.width, height: lhs.height + rhs.height)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

extension UIView {
    var frameOnWindow: CGRect {
        convert(bounds, to: nil)
    }
    
    var safeAreaHeight: CGFloat {
        bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
    }
}

extension UIDevice {
    var isiPad: Bool {
        model.hasPrefix("iPad")
    }
}

extension UIViewController {
    var rootViewController: UIViewController {
        var current = self
        while let next = current.parent {
            current = next
        }
        return current
    }
}
