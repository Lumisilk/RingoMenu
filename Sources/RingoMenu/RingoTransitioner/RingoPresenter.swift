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
    weak var sizingDelegate: RingoPopoverSizingDelegate?
    
    init(
        sourceView: UIView,
        backgroundView: UIView?,
        sizingDelegate: RingoPopoverSizingDelegate?,
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController
    ) {
        self.sourceView = sourceView
        self.backgroundView = backgroundView
        self.sizingDelegate = sizingDelegate
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
        let availableSize = frameCalculator.availableSize(containerView: containerView)
        let preferredSize = sizingDelegate?.sizeThatFits(in: availableSize) ?? presentedViewController.view.sizeThatFits(availableSize)
        return frameCalculator.calculateFrame(
            containerView: containerView,
            sourceView: sourceView,
            preferredSize: preferredSize
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView, let contentView = presentedViewController.view else { return }
        
        gestureFallbackView.frame = containerView.bounds
        containerView.addSubview(gestureFallbackView)
        
        if let backgroundView {
            backgroundView.frame = foregroundContainerView.bounds
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
}
