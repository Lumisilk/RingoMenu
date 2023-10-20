//
//  RingoPresenter.swift
//  
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

final class RingoPresenter: UIPresentationController {
    
    let sourceView: UIView
    let backgroundView: UIView?
    let foregroundContainerView = UIView()
    let shadowView = ShadowView()
    let gestureFallbackView: GestureFallbackView
    
    let frameCalculator: FrameCalculator = UIMenuFrameCalculator()
    
    private var observation: NSKeyValueObservation?
    
    init(
        sourceView: UIView,
        backgroundView: UIView?,
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController
    ) {
        self.sourceView = sourceView
        self.backgroundView = backgroundView
        gestureFallbackView = GestureFallbackView(
            targetView: presentingViewController.rootViewController.view!,
            action: { presentingViewController.dismiss(animated: true) }
        )
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override var presentedView: UIView? {
        foregroundContainerView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }
        return frameCalculator.calculateFrame(
            containerView: containerView,
            sourceView: sourceView,
            preferredSize: presentedViewController.preferredContentSize
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView, let contentView = presentedViewController.view else { return }
        
        gestureFallbackView.frame = containerView.bounds
        containerView.addSubview(gestureFallbackView)
        
        if let backgroundView {
            backgroundView.frame = foregroundContainerView.bounds
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.clipsToBounds = true
            backgroundView.layer.cornerRadius = 13
            backgroundView.layer.cornerCurve = .circular
            foregroundContainerView.addSubview(backgroundView)
        }
        
        shadowView.bounds.size = foregroundContainerView.bounds.size + CGSize(width: 300, height: 300)
        shadowView.center = foregroundContainerView.center
        foregroundContainerView.addSubview(shadowView)
        
        contentView.frame = foregroundContainerView.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 13
        contentView.layer.cornerCurve = .circular
        foregroundContainerView.addSubview(contentView)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        observation = observe(\.presentedViewController.preferredContentSize, options: [.old, .new]) { presenter, change in
            if let new = change.newValue, new != change.oldValue {
                presenter.updateFrame(newPreferredSize: new)
            }
        }
    }
    
    override func dismissalTransitionWillBegin() {
        observation = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if observation != nil {
            updateFrame()
        }
    }
    
    func updateFrame(newPreferredSize: CGSize? = nil) {
        guard let containerView else { return }
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.9)
        animator.addAnimations {
            self.foregroundContainerView.frame = self.frameCalculator.calculateFrame(
                containerView: containerView,
                sourceView: self.sourceView,
                preferredSize: newPreferredSize ?? self.presentedViewController.preferredContentSize
            )
        }
        animator.startAnimation()
    }
}
