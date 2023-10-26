//
//  RingoPresenter.swift
//  
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit
import Combine

/// RingoPresenter responsible for gesture interactions and view configurations.
final class RingoPresenter: UIPresentationController {
    
    let sourceView: UIView
    let foregroundContainerView = UIView()
    let shadowView = ShadowView()
    var gestureFallbackView: GestureFallbackView!
    let animator: RingoAnimator
    
    let config: RingoPopoverConfiguration
    
    private let waitForPresentPublisher = PassthroughSubject<Void, Never>()
    private var cancellable: AnyCancellable?
    
    weak var ringoPopoverDelegate: RingoPopoverDelegate?
    
    init(
        config: RingoPopoverConfiguration,
        sourceView: UIView,
        animator: RingoAnimator,
        ringoPopoverDelegate: RingoPopoverDelegate?,
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController
    ) {
        self.config = config
        self.sourceView = sourceView
        self.animator = animator
        self.ringoPopoverDelegate = ringoPopoverDelegate
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gestureFallbackView = GestureFallbackView(
            backgroundView: presentingViewController.rootViewController.view!,
            action: { [weak self] in self?.dismissWithDelegate() }
        )
    }
    
    override var presentedView: UIView? {
        foregroundContainerView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView, let contentView = presentedViewController.view else { return .zero }
        
        let preferredSize: CGSize
        if presentedViewController.preferredContentSize != .zero {
            preferredSize = presentedViewController.preferredContentSize
        } else {
            let availableSize = config.frameCalculator.availableContainerSize(containerView: containerView)
            preferredSize = contentView.systemLayoutSizeFitting(availableSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultHigh)
        }
        
        return config.frameCalculator.calculateFrame(
            containerView: containerView,
            sourceView: sourceView,
            preferredSize: preferredSize
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
        guard let containerView else { return }
        
        // Wait until the content view's size has stabilized before starting the presentation animation.
        cancellable = waitForPresentPublisher
            .debounce(for: RunLoop.main.minimumTolerance, scheduler: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                animator.present(foregroundContainerView, containerView: containerView, finalFrame: frameOfPresentedViewInContainerView)
                cancellable = nil
            }
        
        animator.resize(foregroundContainerView, containerView: containerView, to: frameOfPresentedViewInContainerView)
        waitForPresentPublisher.send(())
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard let containerView else { return }
        let finalFrame = frameOfPresentedViewInContainerView
        if foregroundContainerView.frame != finalFrame {
            animator.resize(foregroundContainerView, containerView: containerView, to: finalFrame)
            waitForPresentPublisher.send(())
        }
    }
    
    // MARK: - Custom methods
    
    /// Dismiss then call the delegate's `ringoPopoverDidDismissed` method.
    func dismissWithDelegate() {
        presentingViewController.dismiss(animated: true) { [ringoPopoverDelegate] in
            ringoPopoverDelegate?.ringoPopoverDidDismissed()
        }
    }
    
    /// Toggles the visibility of the background view and the shadow view behind the popover.
    public func setBackgroundViewHidden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.shadowView.alpha = isHidden ? 0 : 0.1
            self.config.backgroundView?.alpha = isHidden ? 0 : 1
        }
    }
}
