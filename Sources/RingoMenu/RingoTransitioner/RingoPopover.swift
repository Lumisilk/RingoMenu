//
//  RingoTransitioner.swift
//  
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

public final class RingoPopover: NSObject, UIViewControllerTransitioningDelegate {
    
    private let sourceView: UIView
    private let animator: RingoAnimator
    private let interactiveTransition = UIPercentDrivenInteractiveTransition()
    
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
