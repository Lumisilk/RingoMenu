//
//  RingoContainerView.swift
//
//
//  Created by Lumisilk on 2023/11/07.
//

import UIKit

final class RingoContainerView: UIView {
    
    private let cornerRadius: CGFloat = 13
    
    private let sourceView: UIView
    private let backgroundView: UIView?
    private let shadowView = ShadowView()
    private var contentView: UIView!
    
    init(sourceView: UIView, backgroundView: UIView?) {
        self.sourceView = sourceView
        self.backgroundView = backgroundView
        super.init(frame: .zero)
        
        // Background
        backgroundColor = nil
        if let backgroundView {
            backgroundView.frame = bounds
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.clipsToBounds = true
            backgroundView.layer.cornerRadius = cornerRadius
            backgroundView.layer.cornerCurve = .circular
            addSubview(backgroundView)
        }
        
        // Shadow
        shadowView.bounds.size = bounds.size + CGSize(width: 300, height: 300)
        shadowView.center = bounds.center
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(shadowView)
    }
    
    func setupContentView(_ contentView: UIView) {
        self.contentView = contentView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.cornerCurve = .circular
        addSubview(contentView)
    }
    
    // Feature: Focus
    private var focusAnimator: UIViewPropertyAnimator?
    
    func focusOnFrame(_ frame: CGRect) {
        let mask = UIView(frame: contentView.bounds)
        mask.backgroundColor = .white
        contentView.mask = mask
        
        focusAnimator?.stopAnimation(true)
        focusAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9)
        focusAnimator?.addAnimations { [backgroundView, shadowView] in
            backgroundView?.autoresizingMask = []
            backgroundView?.frame = frame
            
            shadowView.autoresizingMask = []
            shadowView.center = frame.center
            shadowView.bounds.size = frame.size + CGSize(width: 300, height: 300)
            
            mask.frame = frame
        }
        focusAnimator?.startAnimation()
    }
    
    func unfocus() {
        focusAnimator?.stopAnimation(true)
        focusAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9)
        focusAnimator?.addAnimations { [backgroundView, shadowView, contentView] in
            backgroundView?.frame = self.bounds
            backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            shadowView.center = self.bounds.center
            shadowView.bounds.size = self.bounds.size + CGSize(width: 300, height: 300)
            shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            contentView?.mask?.frame = self.bounds
        }
        focusAnimator?.addCompletion { [contentView] _ in
            contentView?.mask = nil
        }
        focusAnimator?.startAnimation()
    }
    
    func setBackgroundHidden(_ isHidden: Bool) {
        focusAnimator?.stopAnimation(true)
        focusAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9)
        focusAnimator?.addAnimations { [backgroundView, shadowView] in
            backgroundView?.alpha = isHidden ? 0 : 1
            shadowView.alpha = isHidden ? 0 : 0.1
        }
        focusAnimator?.startAnimation()
    }
    
    // Feature: Hover scale
    
    private var isHovering = false
    private var scaleAnimator: UIViewPropertyAnimator?
    private var originalFrame: CGRect = .zero
    
    // start to shrink: extend side 45pt, other size: 0pt
    // stop to shrink: extend side 110, other size 65
    // scale ratio: 0.8
    func hoverGestureLocationChanged(_ location: CGPoint) {
        if !isHovering {
            originalFrame = globalFrame
            isHovering = true
        }
        let distanceToSourceView = sourceView.globalFrame.chebyshevDistance(to: location)
        let distanceToContainer = originalFrame.chebyshevDistance(to: location)
        let distance = min(distanceToSourceView, distanceToContainer)
        let shrinkRatio = min(1, distance / 65.0)
        let scale = 1 - 0.2 * shrinkRatio
        
        scaleAnimator?.stopAnimation(true)
        scaleAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
        scaleAnimator?.addAnimations {
            self.transform = .init(scaleX: scale, y: scale)
        }
        scaleAnimator?.startAnimation()
    }
    
    func hoverGestureReleased() {
        isHovering = false
        scaleAnimator?.stopAnimation(true)
        scaleAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.95)
        scaleAnimator?.addAnimations {
            self.transform = .identity
        }
        scaleAnimator?.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
