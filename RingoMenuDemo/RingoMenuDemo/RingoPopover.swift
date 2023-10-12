//
//  RingoPopover.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/11.
//

import SwiftUI
import RingoMenu

class RingoHostingController<Content: View>: UIHostingController<Content>, RingoPopoverSizingDelegate {
    
    private let ringoPopover: RingoPopoverController
    
    init(sourceView: UIView, rootView: Content) {
        ringoPopover = RingoPopoverController(sourceView: sourceView)
        super.init(rootView: rootView)
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
    }
}
