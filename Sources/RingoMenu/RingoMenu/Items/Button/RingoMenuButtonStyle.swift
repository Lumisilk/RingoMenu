//
//  RingoMenuButtonStyle.swift
//  
//
//  Created by Lumisilk on 2023/11/02.
//

import Combine
import SwiftUI

struct RingoMenuButtonStyle: ButtonStyle {
    
    @EnvironmentObject private var coordinator: RingoMenuCoordinator
    @Environment(\.isEnabled) private var isEnabled
    
    var id: AnyHashable
    @State private var isHovered = false
    
    let action: () -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        let isHighlighted = coordinator.isHoverGestureEnable ? isHovered : configuration.isPressed
        
        configuration.label
            .backport.background {
                if isHighlighted {
                    VisualEffectView.highlightedBackground
                }
            }
            .backport.foregroundColor(isEnabled ? .primary : .secondary)
            .buttonStyle(.plain)
            .modifier(HoverGestureModifier(id: id, onHighlight: { isHovered = $0 }, onTrigger: action))
    }
}
