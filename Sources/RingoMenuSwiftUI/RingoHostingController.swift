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
    private let ringoPopover: RingoPopoverController
    
    public init(sourceView: UIView, rootView: some View) {
        ringoPopover = RingoPopoverController(sourceView: sourceView)
        super.init(rootView: AnyView(rootView))
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func updatePreferredContentSizeIfNeeded() {
        let newSize = sizeThatFits(in: UIView.layoutFittingExpandedSize)
        if preferredContentSize != newSize {
            preferredContentSize = newSize
        }
    }
}
