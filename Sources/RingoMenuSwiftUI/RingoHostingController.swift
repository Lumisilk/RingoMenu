//
//  RingoHostingController.swift
//
//
//  Created by Lumisilk on 2023/10/12.
//

import RingoMenu
import SwiftUI
import SwiftUIPresent

public final class RingoHostingController: UIHostingController<AnyView>, RingoPopoverSizingDelegate {
    private let ringoPopover: RingoPopoverController
    
    public init(sourceView: UIView, rootView: AnyView) {
        ringoPopover = RingoPopoverController(sourceView: sourceView)
        super.init(rootView: rootView)
        
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
}
