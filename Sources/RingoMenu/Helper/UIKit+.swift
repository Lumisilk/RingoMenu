//
//  UIKit+.swift
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
    
    var debugRounded: CGRect {
        CGRect(x: minX.rounded(), y: minY.rounded(), width: width.rounded(), height: height.rounded())
    }
    
    func chebyshevDistance(to point: CGPoint) -> CGFloat {
        let xDistance: CGFloat =
        switch point.x {
        case ..<minX:
            minX - point.x
        case maxX...:
            point.x - maxX
        default:
            0
        }
        
        let yDistance: CGFloat =
        switch point.y {
        case ..<minY:
            minY - point.y
        case maxY...:
            point.y - maxY
        default:
            0
        }
        
        return max(xDistance, yDistance)
    }
}

extension UIView {    
    var safeAreaWidth: CGFloat {
        bounds.width - safeAreaInsets.left - safeAreaInsets.right
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

extension UIVisualEffectView {
    func setGroupName(_ name: String) {
        ringoDebug(#function, name)
        let selector = NSSelectorFromString("_" + ["Name", "Group", "set"].reversed().joined() + ":")
        if responds(to: selector) {
            perform(selector, with: name as NSString)
        } else {
            ringoDebug("Cannot set group name on UIVisualEffectView.")
        }
    }
    
    static func menuBackground(groupName: String) -> UIVisualEffectView {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blur.setGroupName(groupName)
        return blur
    }
}
