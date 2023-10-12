//
//  RingoTransitioner.swift
//  
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

public final class RingoPopoverController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let sourceView: UIView
    private let animator: RingoAnimator
    private let interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    public var backgroundView: UIView? = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    
    public weak var sizingDelegate: RingoPopoverSizingDelegate?
    
    public init(sourceView: UIView) {
        self.sourceView = sourceView
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
            sourceView: sourceView,
            backgroundView: backgroundView,
            sizingDelegate: sizingDelegate,
            presentedViewController: presented,
            presenting: presenting ?? source
        )
    }
}
