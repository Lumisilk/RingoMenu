//
//  RingoContainerView.swift
//
//
//  Created by Lumisilk on 2023/11/07.
//

import UIKit

final class RingoContainerView: UIView {
    
    private let cornerRadius: CGFloat = 13
    
    private let backgroundView: UIView?
    
    private let shadowView = ShadowView()
    
    private var contentView: UIView!
    
    private var focusAnimator: UIViewPropertyAnimator?
    
    init(backgroundView: UIView? = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))) {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
