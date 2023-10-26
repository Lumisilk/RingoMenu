//
//  FrameCalculator.swift
//
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

/// Protocol used by RingoPopover to calculate the final frame of the popover.
public protocol FrameCalculator {
    
    /// This method returns the available size used for layout the content view.
    /// - Parameter containerView: The container view provided by the presentation controller.
    /// - Returns: The maximum available size for displaying the content view.
    func availableContainerSize(containerView: UIView) -> CGSize
    
    /// RingoPopover uses this method to determine the final frame of the popover.
    ///
    /// - Parameters:
    ///   - containerView: The container view provided by the presentation controller.
    ///   - sourceView: The view containing the anchor rectangle for the popover.
    ///   - preferredSize: The preferred size of the presented controller.
    /// - Returns: The final frame on the container view for the popover.
    func calculateFrame(containerView: UIView, sourceView: UIView, preferredSize: CGSize) -> CGRect
}

/// A FrameCalculator that closely mimics the layout behavior of UIMenu.
public struct UIMenuFrameCalculator: FrameCalculator {
    
    /// The minimum horizontal margin that must be ensured between the popover and the containerView. The default value is 16.
    public var horizontalPadding: CGFloat = 16
    
    /// The maximum width of the popover.
    ///
    /// The default value is 250. You can set this value to .infinity to indicate there is no width limitation.
    public var maxWidth: CGFloat = 250
    
    /// The maximum height of the popover.
    ///
    /// The default value is 883.5. You can set this value to .infinity to indicate there is no width limitation.
    public var maxHeight: CGFloat = 883.5
    
    /// The vertical spacing between the popover and the sourceview.
    public var spacingBetweenSourceView: CGFloat = 6
    
    public init() {}
    
    public func availableContainerSize(containerView: UIView) -> CGSize {
        CGSize(width: availableWidth(containerView), height: availableHeight(containerView))
    }
    
    public func calculateFrame(containerView: UIView, sourceView: UIView, preferredSize: CGSize) -> CGRect {
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
            let sourceRectBottom = sourceRect.maxY + spacingBetweenSourceView
            let upperY = containerSize.height - containerView.safeAreaInsets.bottom - contentSize.height
            y = min(max(safeAreaTop, sourceRectBottom), upperY)
            
        } else {
            // Bottom alignment
            let safeAreaBottom = containerSize.height - containerView.safeAreaInsets.bottom
            let sourceRectTop = sourceRect.minY - spacingBetweenSourceView
            let lowerY = containerView.safeAreaInsets.top + contentSize.height
            y = max(min(safeAreaBottom, sourceRectTop), lowerY) - contentSize.height
        }
        
        return CGPoint(x: x, y: y)
    }
}
