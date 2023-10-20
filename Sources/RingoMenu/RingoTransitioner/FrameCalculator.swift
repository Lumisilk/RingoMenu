//
//  FrameCalculator.swift
//
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

protocol FrameCalculator {
    func calculateFrame(containerView: UIView, sourceView: UIView, preferredSize: CGSize) -> CGRect
}

struct UIMenuFrameCalculator: FrameCalculator {
    
    let horizontalPadding: CGFloat = 8
    var maxWidth: CGFloat = 250
    var maxHeight: CGFloat = 883.5
    
    func calculateFrame(containerView: UIView, sourceView: UIView, preferredSize: CGSize) -> CGRect {
        let contentSize = CGSize(
            width: min(preferredSize.width, availableWidth(containerView)),
            height: min(preferredSize.height, availableHeight(containerView))
        )
        let origin = calculateOrigin(
            containerView: containerView,
            sourceView: sourceView,
            contentSize: contentSize
        )
        return CGRect(origin: origin, size: contentSize)
    }
    
    private func availableWidth(_ containerView: UIView) -> CGFloat {
        min(maxWidth, containerView.safeAreaWidth - horizontalPadding * 2)
    }
    
    private func availableHeight(_ containerView: UIView) -> CGFloat {
        let isPortrait = containerView.bounds.height > containerView.bounds.width
        /// The device has full-screen display like iPhone X or later
        let isFullScreen = containerView.safeAreaInsets.bottom > 0
        
        let diff: CGFloat =
        if UIDevice.current.isiPad { 20.5 }
        else if isFullScreen { isPortrait ? 108 : 28 }
        else { isPortrait ? 116.5 : 36.5 }
        
        return min(maxHeight, containerView.safeAreaHeight - diff)
    }
    
    private func calculateOrigin(
        containerView: UIView,
        sourceView: UIView,
        contentSize: CGSize
    ) -> CGPoint {
        let containerSize = containerView.bounds.size
        let sourceRect = sourceView.convert(sourceView.bounds, to: containerView)
        // space between source view and content view
        let spacing: CGFloat = 5.17
        let x: CGFloat
        let y: CGFloat
        
        let sourceCenterXRatio = sourceRect.midX / containerSize.width
        if sourceCenterXRatio <= 0.45 {
            // Left alignment
            x = max(horizontalPadding, min(containerSize.width - horizontalPadding - contentSize.width, sourceRect.minX - 4))
            
        } else if sourceCenterXRatio <= 0.55 {
            // Center alignment
            let halfWidth = contentSize.width / 2
            let midXLeftMost = max(horizontalPadding + halfWidth, sourceRect.midX)
            let midXRightMost = min(containerSize.width - horizontalPadding - halfWidth, sourceRect.midX)
            
            if midXLeftMost == midXRightMost {
                x = midXLeftMost - halfWidth
            } else if midXLeftMost > midXRightMost {
                x = containerView.bounds.midX - halfWidth
            } else {
                let midX = switch sourceRect.midX {
                    case midXLeftMost...midXRightMost: sourceRect.midX
                    case ..<midXLeftMost: midXLeftMost
                    default: midXRightMost
                }
                x = midX - halfWidth
            }
            
        } else {
            // Right alignment
            let right = min(containerSize.width - horizontalPadding, max(horizontalPadding + contentSize.width, sourceRect.maxX + 4))
            x = right - contentSize.width
        }
        
        let sourceCenterYRatio = sourceRect.midY / containerSize.height
        if sourceCenterYRatio < 0.5 {
            // Top alignment
            let safeAreaTop = containerView.safeAreaInsets.top
            let sourceRectBottom = sourceRect.maxY + spacing
            let upperY = containerSize.height - containerView.safeAreaInsets.bottom - contentSize.height
            y = min(max(safeAreaTop, sourceRectBottom), upperY)
            
        } else {
            // Bottom alignment
            let safeAreaBottom = containerSize.height - containerView.safeAreaInsets.bottom
            let sourceRectTop = sourceRect.minY - spacing
            let lowerY = containerView.safeAreaInsets.top + contentSize.height
            y = max(min(safeAreaBottom, sourceRectTop), lowerY) - contentSize.height
        }
        
        return CGPoint(x: x, y: y)
    }
}
