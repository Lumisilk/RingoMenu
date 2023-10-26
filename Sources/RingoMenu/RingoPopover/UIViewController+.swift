import UIKit

public extension UIViewController {
    /// Update the preferred content size based on container view's size provided by RingoPresenter.
    func updatePreferredContentSizeBasedOnRingoPopover() {
        guard let ringoPresenter = presentationController as? RingoPresenter,
              let containerView = ringoPresenter.containerView
        else { return }
        
        let availableSize = ringoPresenter.config.frameCalculator.availableContainerSize(containerView: containerView)
        let newSize = view.systemLayoutSizeFitting(availableSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultHigh)
        
        if preferredContentSize != newSize {
            ringoDebug("preferredSize will set", newSize)
            preferredContentSize = newSize
        }
    }
}
