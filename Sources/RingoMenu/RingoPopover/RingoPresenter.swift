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
    var gestureFallbackView: GestureFallbackView!
    let ringoContainer: RingoContainerView
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
        self.ringoContainer = RingoContainerView(sourceView: sourceView, backgroundView: config.backgroundView)
        self.animator = animator
        self.ringoPopoverDelegate = ringoPopoverDelegate
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        gestureFallbackView = GestureFallbackView(
            backgroundView: presentingViewController.rootViewController.view!,
            action: { [weak self] in self?.dismissWithDelegate() }
        )
    }
    
    override var presentedView: UIView? {
        ringoContainer
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }
        
        let preferredSize: CGSize
        if presentedViewController.preferredContentSize != .zero {
            preferredSize = presentedViewController.preferredContentSize
        } else {
            preferredSize = config.frameCalculator.availableContainerSize(containerView: containerView)
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
        
        ringoContainer.setupContentView(contentView)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard let containerView else { return }
        
        // Wait until the content view's size has stabilized before starting the presentation animation.
        cancellable = waitForPresentPublisher
            .debounce(for: RunLoop.main.minimumTolerance, scheduler: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                animator.present(ringoContainer, containerView: containerView, finalFrame: frameOfPresentedViewInContainerView)
                cancellable = nil
            }
        
        animator.resize(ringoContainer, containerView: containerView, to: frameOfPresentedViewInContainerView)
        waitForPresentPublisher.send(())
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard let containerView else { return }
        let finalFrame = frameOfPresentedViewInContainerView
        if ringoContainer.frame != finalFrame {
            animator.resize(ringoContainer, containerView: containerView, to: finalFrame)
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
}
