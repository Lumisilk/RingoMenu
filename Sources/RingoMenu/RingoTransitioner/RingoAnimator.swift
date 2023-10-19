//
//  RingoAnimator.swift
//
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

class RingoAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var sourceView: UIView
    var isPresenting: Bool = true
    var presentingAnimator: UIViewPropertyAnimator?
    var dismissAnimator: UIViewPropertyAnimator?
    
    init(sourceView: UIView, isPresenting: Bool = true) {
        self.sourceView = sourceView
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        isPresenting ? 0.5: 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to),
                  let toVC = transitionContext.viewController(forKey: .to)
            else { return }
            
            let finalFrame = transitionContext.finalFrame(for: toVC)
            toView.layer.anchorPoint = calculateAnchorPoint(sourceCenter: sourceView.frameOnWindow.center, targetRect: finalFrame)
            toView.alpha = 0
            toView.frame = finalFrame
            toView.bounds.size.height *= 0.2
            toView.transform = CGAffineTransform(scaleX: 0.2, y: 1)
            toView.layer.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 1, y: 0.2))
            container.addSubview(toView)
            
            let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.78)
            animator.isInterruptible = true
            presentingAnimator = animator
            animator.addAnimations {
                toView.alpha = 1
                toView.transform = .identity
                toView.bounds.size.height = finalFrame.height
                toView.layer.sublayerTransform = CATransform3DMakeAffineTransform(.identity)
            }
            animator.addCompletion { [weak self] position in
                if transitionContext.transitionWasCancelled {
                    toView.removeFromSuperview()
                }
                self?.presentingAnimator = nil
            }
            animator.startAnimation()
            
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
        } else {
            guard let fromView = transitionContext.view(forKey: .from)
            else { return }
            
            presentingAnimator?.stopAnimation(true)
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
            dismissAnimator = animator
            animator.addAnimations {
                fromView.alpha = 0
                fromView.transform = CGAffineTransform(scaleX: 0.2, y: 1)
                fromView.layer.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 1, y: 0.2))
            }
            animator.addCompletion { position in
                let isCancelled = transitionContext.transitionWasCancelled
                if !isCancelled {
                    fromView.removeFromSuperview()
                }
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
        }
    }
    
    private func calculateAnchorPoint(sourceCenter: CGPoint, targetRect: CGRect) -> CGPoint {
        var x = (sourceCenter.x - targetRect.minX) / targetRect.width
        var y = (sourceCenter.y - targetRect.minY) / targetRect.height
        x = min(1, max(0, x))
        y = min(1, max(0, y))
        return CGPoint(x: x, y: y)
    }
}
