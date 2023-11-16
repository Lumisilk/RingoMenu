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
    
    let config: RingoMenuButtonConfiguration
    let label: Label
    let action: () -> Void
    
    public init(
        config: RingoMenuButtonConfiguration = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.config = config
        self.label = label()
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
        .backport.foregroundColor(config.isDestructive ? Color.red: nil)
        .buttonStyle(RingoMenuButtonStyle(id: id, action: onTrigger))
    }
    
    private func onTrigger() {
        action()
        if !config.keepsMenuPresented {
            popoverCoordinator.dismiss()
        }
    }
}

public extension RingoMenuButton where Label == RingoMenuButtonLabel {
    init(
        title: String,
        subtitle: String? = nil,
        image: Image? = nil,
        config: RingoMenuButtonConfiguration = .init(),
        action: @escaping () -> Void
    ) {
        self.init(config: config, action: action) {
            RingoMenuButtonLabel(title: title, subtitle: subtitle, image: image, config: config)
        }
    }
}
