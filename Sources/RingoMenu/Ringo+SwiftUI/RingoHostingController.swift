//
//  RingoHostingController.swift
//
//
//  Created by Lumisilk on 2023/10/12.
//

import SwiftUI
import SwiftUIPresent

public final class RingoHostingController: UIHostingController<AnyView> {
    let ringoPopover: RingoPopover
    
    public init(
        sourceView: UIView,
        onDismiss: (() -> Void)? = nil,
        rootView: some View
    ) {
        let config = RingoPopoverConfiguration(onDismiss: onDismiss)
        ringoPopover = RingoPopover(sourceView: sourceView, config: config)
        let coordinator = RingoPopoverCoordinator()
        let view = rootView
            .environment(\.ringoPopoverCoordinator, coordinator)
            .eraseToAnyView()
        super.init(rootView: view)
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
        coordinator.hostingController = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSizeIfNeeded()
    }
    
    private func updatePreferredContentSizeIfNeeded() {
        let newSize = sizeThatFits(in: UIView.layoutFittingExpandedSize)
        if preferredContentSize != newSize {
            preferredContentSize = newSize
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
