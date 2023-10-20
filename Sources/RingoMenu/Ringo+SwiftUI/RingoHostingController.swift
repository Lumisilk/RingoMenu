//
//  RingoHostingController.swift
//
//
//  Created by Lumisilk on 2023/10/12.
//

import SwiftUI
import SwiftUIPresent

public final class RingoHostingController: UIHostingController<AnyView> {
    private let ringoPopover: RingoPopover
    private let coordinator = RingoPopoverCoordinator()
    
    public init(
        sourceView: UIView,
        onDismiss: (() -> Void)? = nil,
        rootView: some View
    ) {
        ringoPopover = RingoPopover(
            sourceView: sourceView,
            config: RingoPopoverConfiguration(onDismiss: onDismiss)
        )
        let view = AnyView(
            rootView
                .environment(\.ringoPopoverCoordinator, coordinator)
        )
        super.init(rootView: view)
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
        
        coordinator.dismiss = { [weak self] in
            self?.presentingViewController?.dismiss(animated: true) {
                onDismiss?()
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePreferredContentSizeIfNeeded()
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
