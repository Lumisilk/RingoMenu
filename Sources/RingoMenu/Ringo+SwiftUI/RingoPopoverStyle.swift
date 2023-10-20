//
//  RingoPopoverStyle.swift
//  
//
//  Created by Lumisilk on 2023/10/12.
//

import SwiftUI
import SwiftUIPresent

public struct RingoPopoverStyle: PresentationStyle {
    public func makeHostingController(_ configuration: PresentationConfiguration) -> RingoHostingController {
        RingoHostingController(
            sourceView: configuration.anchorView,
            onDismiss: { configuration.isPresented.wrappedValue = false },
            rootView: configuration.content
        )
    }
    
    public func update(_ hostingController: RingoHostingController, configuration: PresentationConfiguration) {
        hostingController.rootView = configuration.content
    }
}

public extension PresentationStyle where Self == RingoPopoverStyle {
    static var ringoPopover: RingoPopoverStyle {
        RingoPopoverStyle()
    }
}
