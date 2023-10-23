//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/23.
//

import SwiftUI

public struct RingoMenuButton<Label: View>: View {
    
    @Environment(\.ringoPopoverCoordinator) private var popoverCoordinator
    
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
            action()
            if !attributes.contains(.keepsMenuPresented) {
                popoverCoordinator.dismiss()
            }
        } label: {
            label
        }
        .buttonStyle(RingoMenuButtonStyle())
    }
}

public extension RingoMenuButton where Label == RingoMenuPlainButtonLabel {
    init(
        title: String,
        image: Image? = nil,
        attributes: RingoMenuButtonAttributes = [],
        action: @escaping () -> Void
    ) {
        self.init(action: action) {
            RingoMenuPlainButtonLabel(title: title, image: image, attributes: attributes)
        }
    }
}
