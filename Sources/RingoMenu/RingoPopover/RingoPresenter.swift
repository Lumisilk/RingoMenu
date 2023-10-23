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
    let animator: RingoAnimator
    
    public var config: RingoPopoverConfiguration
    
    init(
        config: RingoPopoverConfiguration,
        sourceView: UIView,
        animator: RingoAnimator,
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController
    ) {
        self.config = config
        self.sourceView = sourceView
        self.animator = animator
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gestureFallbackView = GestureFallbackView(
            backgroundView: presentingViewController.rootViewController.view!,
            action: { [weak self] in self?.dismissWithConfigDismissClosure() }
        )
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
        animator.present(foregroundContainerView, finalFrame: frameOfPresentedViewInContainerView)
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        animator.resize(foregroundContainerView, to: frameOfPresentedViewInContainerView)
    }
    
    // MARK: - Custom methods
    
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
