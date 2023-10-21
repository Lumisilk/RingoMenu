//
//  RingoPresenter.swift
//  
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

/// RingoPresenter responsible for gesture interactions and view configurations.
final class RingoPresenter: UIPresentationController {
    
    let sourceView: UIView
    let foregroundContainerView = UIView()
    let shadowView = ShadowView()
    var gestureFallbackView: GestureFallbackView!
    
    public var config: RingoPopoverConfiguration
    
    private var observation: NSKeyValueObservation?
    
    init(
        config: RingoPopoverConfiguration,
        sourceView: UIView,
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController
    ) {
        self.config = config
        self.sourceView = sourceView
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gestureFallbackView = GestureFallbackView(
            backgroundView: presentingViewController.rootViewController.view!,
            action: { [weak self] in self?.dismissWithConfigDismissClosure() }
        )
    }
    
    deinit {
        print(Self.self, #function)
    }
    
    override var presentedView: UIView? {
        foregroundContainerView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }
        return config.frameCalculator.calculateFrame(
            containerView: containerView,
            sourceView: sourceView,
            preferredSize: presentedViewController.preferredContentSize
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView, let contentView = presentedViewController.view else { return }
        
        gestureFallbackView.frame = containerView.bounds
        containerView.addSubview(gestureFallbackView)
        
        if let backgroundView = config.backgroundView {
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
        // Observe the presented view controller's `preferredContentSize`
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
    
    private func updateFrame(newPreferredSize: CGSize? = nil) {
        guard let containerView else { return }
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.9)
        animator.addAnimations {
            self.foregroundContainerView.frame = self.config.frameCalculator.calculateFrame(
                containerView: containerView,
                sourceView: self.sourceView,
                preferredSize: newPreferredSize ?? self.presentedViewController.preferredContentSize
            )
        }
        animator.startAnimation()
    }
    
    /// Dismiss then call the configuration's `onDismiss` closure.
    func dismissWithConfigDismissClosure() {
        presentingViewController.dismiss(animated: true) { [config] in
            config.onDismiss?()
        }
    }
    
    /// Toggles the visibility of the background view and the shadow view behind the popover.
    func setBackgroundViewHidden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.shadowView.alpha = isHidden ? 0 : 0.1
            self.config.backgroundView?.alpha = isHidden ? 0 : 1
        }
    }
}
