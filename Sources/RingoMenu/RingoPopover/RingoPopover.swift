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
    
    private var sourceView: UIView
    private var animator: RingoAnimator
    private var interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    public var config: RingoPopoverConfiguration
    
    public weak var ringoPopoverDelegate: RingoPopoverDelegate?
    
    public init(sourceView: UIView, config: RingoPopoverConfiguration) {
        self.sourceView = sourceView
        self.config = config
        self.animator = RingoAnimator(sourceView: sourceView)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.state = .willTransition
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.state = .willDismiss
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
            animator: animator,
            ringoPopoverDelegate: ringoPopoverDelegate,
            presentedViewController: presented,
            presenting: presenting ?? source
        )
    }
}
