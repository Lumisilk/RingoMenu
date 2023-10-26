//
//  RingoHostingController.swift
//
//
//  Created by Lumisilk on 2023/10/12.
//

import SwiftUI

public final class RingoHostingController: UIHostingController<AnyView> {
    let ringoPopover: RingoPopover
    let coordinator = RingoPopoverCoordinator()
    var onDismiss: (() -> Void)?
    
    public init(
        sourceView: UIView,
        rootView: some View,
        config: RingoPopoverConfiguration = RingoPopoverConfiguration(),
        onDismiss: (() -> Void)? = nil
    ) {
        ringoPopover = RingoPopover(sourceView: sourceView, config: config)
        self.onDismiss = onDismiss
        let view = rootView
            .environment(\.ringoPopoverCoordinator, coordinator)
            .eraseToAnyView()
        super.init(rootView: view)
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
        ringoPopover.ringoPopoverDelegate = self
    }
    
    func update(rootView: some View, onDismiss: @escaping () -> Void) {
        self.rootView = rootView
            .environment(\.ringoPopoverCoordinator, coordinator)
            .eraseToAnyView()
        self.onDismiss = onDismiss
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
        coordinator.ringoPresenter = presentationController as? RingoPresenter
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSizeBasedOnRingoPopover()
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RingoHostingController: RingoPopoverDelegate {
    public func ringoPopoverDidDismissed() {
        onDismiss?()
    }
}
