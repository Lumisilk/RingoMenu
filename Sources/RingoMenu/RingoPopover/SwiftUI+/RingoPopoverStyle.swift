//
//  RingoPopoverStyle.swift
//
//
//  Created by Lumisilk on 2023/10/12.
//

import SwiftUI
import SwiftUIPresent

public struct RingoPopoverStyle: PresentationStyle {
    
    var config = RingoPopoverConfiguration()
    
    public func makeHostingController(_ configuration: PresentationConfiguration) -> RingoHostingController {
        RingoHostingController(
            sourceView: configuration.anchorView,
            config: config, 
            onDismiss: { configuration.isPresented.wrappedValue = false },
            rootView: configuration.content
        )
    }
    
    public func update(_ hostingController: RingoHostingController, configuration: PresentationConfiguration) {
        hostingController.rootView = configuration.content
        hostingController.ringoPopover.config = config
        hostingController.onDismiss = { configuration.isPresented.wrappedValue = false }
    }
}

extension RingoPopoverStyle {
    public func configuration(_ config: RingoPopoverConfiguration) -> RingoPopoverStyle {
        var modified = self
        modified.config = config
        return modified
    }
}

public extension PresentationStyle where Self == RingoPopoverStyle {
    static var ringoPopover: RingoPopoverStyle {
        RingoPopoverStyle()
    }
}
