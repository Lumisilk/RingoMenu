//
//  RingoAnimator2.swift
//
//
//  Created by Lumisilk on 2023/10/22.
//

import UIKit

/// Animator responsible for the presented view's presentation, resizing and dismissal animation.
class RingoAnimator: NSObject {
    
    enum PresentationState {
        case willTransition
        case transitionComplete
        case willDismiss
    }
    
    private let presentingDuration: TimeInterval = 0.5
    private let dismissalDuration: TimeInterval = 0.2
    private let resizingDuration: TimeInterval = 0.5
    
    private var sourceView: UIView
    
    private var presentingAnimator: UIViewPropertyAnimator?
    private var resizingAnimator: UIViewPropertyAnimator?
    
    var state: PresentationState = .willTransition
    
    init(sourceView: UIView) {
        self.sourceView = sourceView
    }
    
    /// Present view AFTER UIKit's presentation transition completion.
    func present(_ presentedView: UIView, containerView: UIView, finalFrame: CGRect) {
        setAnchorPoint(presentedView, containerView: containerView, finalFrame: finalFrame)
        presentedView.frame = finalFrame
        presentedView.bounds.size.height *= 0.2
        presentedView.transform = CGAffineTransform(scaleX: 0.2, y: 1)
        presentedView.layer.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 1, y: 0.2))
        
        let animator = UIViewPropertyAnimator(duration: presentingDuration, dampingRatio: 0.78)
        animator.isInterruptible = true
        presentingAnimator = animator
        
        animator.addAnimations { [presentedView] in
            presentedView.alpha = 1
            presentedView.bounds.size.height = finalFrame.height
            presentedView.transform = .identity
            presentedView.layer.sublayerTransform = CATransform3DMakeAffineTransform(.identity)
        }
        animator.addCompletion { [weak self] _ in
            self?.presentingAnimator = nil
            self?.state = .transitionComplete
        }
        animator.startAnimation()
    }
    
    func resize(_ presentedView: UIView, containerView: UIView,  to finalFrame: CGRect) {
        setAnchorPoint(presentedView, containerView: containerView, finalFrame: finalFrame)
        
        switch state {
        case .willTransition:
            presentedView.frame = finalFrame
            
        case .transitionComplete:
            resizingAnimator?.stopAnimation(true)
            let animator = UIViewPropertyAnimator(duration: resizingDuration, dampingRatio: 0.78)
            animator.isInterruptible = true
            resizingAnimator = animator
            animator.addAnimations { [presentedView] in
                presentedView.frame = finalFrame
            }
            animator.startAnimation()
            
        case .willDismiss:
            break
        }
    }
    
    private func setAnchorPoint(_ presentedView: UIView, containerView: UIView, finalFrame: CGRect) {
        let sourceCenter = sourceView.convert(sourceView.bounds.center, to: containerView)
        var x = (sourceCenter.x - finalFrame.minX) / finalFrame.width
        var y = (sourceCenter.y - finalFrame.minY) / finalFrame.height
        x = min(1, max(0, x))
        y = min(1, max(0, y))
        presentedView.layer.anchorPoint = CGPoint(x: x, y: y)
    }
}

extension RingoAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        state == .willDismiss ? dismissalDuration: 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        switch state {
        case .willTransition:
            // At this point, the Animator won't start the presentation animation yet.
            // It just adds the tansparent view to the containerView.
            guard let toView = transitionContext.view(forKey: .to) else { return }
            toView.alpha = 0
            containerView.addSubview(toView)
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            
        case .willDismiss:
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            presentingAnimator?.stopAnimation(true)
            setAnchorPoint(fromView, containerView: containerView, finalFrame: fromView.frame)
            
            let duration = transitionDuration(using: transitionContext)
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
            animator.addAnimations { [fromView] in
                fromView.alpha = 0
                fromView.transform = CGAffineTransform(scaleX: 0.2, y: 1)
                fromView.layer.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 1, y: 0.2))
            }
            animator.addCompletion { [fromView] _ in
                fromView.removeFromSuperview()
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
            
        case .transitionComplete:
            break
        }
    }
}
