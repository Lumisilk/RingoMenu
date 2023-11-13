//
//  RingoMenuButton.swift
//
//
//  Created by Lumisilk on 2023/10/23.
//

import SwiftUI

public struct RingoMenuButton<Label: View>: View {
    
    @Environment(\.ringoPopoverCoordinator) private var popoverCoordinator
    @EnvironmentObject private var menuCoordinator: RingoMenuCoordinator
    @Namespace private var id
    
    let label: Label
    let attributes: RingoMenuButtonAttributes
    let action: () -> Void
    
    public init(
        attributes: RingoMenuButtonAttributes = [],
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.label = label()
        self.attributes = attributes
        self.action = action
    }
    
    public var body: some View {
        Button {
            if !menuCoordinator.isHoverGestureEnable {
                action()
            }
        } label: {
            label
        }
        .backport.foregroundColor(attributes.contains(.destructive) ? Color.red: nil)
        .buttonStyle(RingoMenuButtonStyle(id: id, action: onTrigger))
    }
    
    private func onTrigger() {
        action()
        if !attributes.contains(.keepsMenuPresented) {
            popoverCoordinator.dismiss()
        }
    }
}

public extension RingoMenuButton where Label == RingoMenuButtonLabel {
    init(
        title: String,
        subtitle: String? = nil,
        image: Image? = nil,
        attributes: RingoMenuButtonAttributes = [],
        action: @escaping () -> Void
    ) {
        self.init(attributes: attributes, action: action) {
            RingoMenuButtonLabel(title: title, subtitle: subtitle, image: image, attributes: attributes)
        }
    }
}
