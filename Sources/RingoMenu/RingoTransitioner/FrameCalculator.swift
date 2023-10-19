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
    func calculateFrame(containerView: UIView, sourceView: UIView, preferredSize: CGSize) -> CGRect {
        let contentSize = CGSize(
            width: min(preferredSize.width, 250),
            height: min(preferredSize.height, availableHeight(containerView: containerView))
        )
        
        let origin = calculateOrigin(
            containerView: containerView,
            sourceView: sourceView,
            contentSize: contentSize
        )
        
        return CGRect(origin: origin, size: contentSize)
    }
    
    private func availableHeight(containerView: UIView) -> CGFloat {
        let isPortrait = containerView.bounds.height / containerView.bounds.width > 1
        /// The device has all screen like iPhone X or later
        let isAllScreen = containerView.safeAreaInsets.bottom > 0
        let diff: CGFloat
        
        if UIDevice.current.isiPad {
            // iPad
            diff = 20.5
            
        } else if isAllScreen {
            // iPhone X and later
            diff = isPortrait ? 108 : 28
            
        } else {
            // iPhone 8, SE, etc.
            diff = isPortrait ? 116.5 : 36.5
        }
        
        return min(883.5, containerView.safeAreaHeight - diff)
    }
    
    private func calculateOrigin(
        containerView: UIView,
        sourceView: UIView,
        contentSize: CGSize
    ) -> CGPoint {
        let containerSize = containerView.bounds.size
        let sourceRect = sourceView.frameOnWindow
        // space between source view and content view
        let spacing: CGFloat = 5.17
        let x: CGFloat
        let y: CGFloat
        
        let sourceCenterXRatio = sourceRect.midX / containerSize.width
        if sourceCenterXRatio <= 0.45 {
            // Left alignment
            x = max(8, sourceRect.minX - 4)
            
        } else if sourceCenterXRatio <= 0.55 {
            // Center alignment
            x = sourceRect.midX - contentSize.width / 2
            
        } else {
            // Right alignment
            let right = min(containerSize.width - 8, sourceRect.maxX + 4)
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
