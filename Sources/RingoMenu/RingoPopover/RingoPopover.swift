//
//  RingoTransitioner.swift
//  
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

/// `RingoPopover` is a concrete implementation that provides
/// both the `RingoAnimator`, which handles the transition animations,
/// and the `RingoPresenter`, which manages gesture interactions and view configurations.
///
/// You set an instance of `RingoPopover` as the transitioning delegate of the view controller you wish to present as a popover.
public class RingoPopover: NSObject, UIViewControllerTransitioningDelegate {
    
    var sourceView: UIView
    var animator: RingoAnimator
    var interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    public var config: RingoPopoverConfiguration
    
    public init(sourceView: UIView, config: RingoPopoverConfiguration) {
        self.sourceView = sourceView
        self.config = config
        animator = RingoAnimator(sourceView: sourceView)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        return animator
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        RingoPresenter(
            config: config,
            sourceView: sourceView,
            presentedViewController: presented,
            presenting: presenting ?? source
        )
    }
}
