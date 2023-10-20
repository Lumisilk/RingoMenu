//
//  RingoHostingController.swift
//
//
//  Created by Lumisilk on 2023/10/12.
//

import RingoMenu
import SwiftUI
import SwiftUIPresent

public final class RingoHostingController: UIHostingController<AnyView> {
    private let ringoPopover: RingoPopover
    
    public init(
        sourceView: UIView,
        onDismiss: (() -> Void)? = nil,
        rootView: some View
    ) {
        ringoPopover = RingoPopover(
            sourceView: sourceView,
            config: RingoPopoverConfiguration(onDismiss: onDismiss)
        )
        super.init(rootView: AnyView(rootView))
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
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
