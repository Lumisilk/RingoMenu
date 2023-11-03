//
//  RingoMenuButtonStyle.swift
//  
//
//  Created by Lumisilk on 2023/11/02.
//

import SwiftUI

struct RingoMenuButtonStyle: ButtonStyle {
    
    @EnvironmentObject private var coordinator: RingoMenuCoordinator
    @Environment(\.isEnabled) private var isEnabled
    @State private var id = UUID()
    
    @State private var isHighlighted = false
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            if #available(iOS 15, *) {
                configuration.label
                    .background { background(highlighted: isHighlighted) }
                    .foregroundStyle(isEnabled ? .primary : .secondary)
            } else {
                configuration.label
                    .background(background(highlighted: isHighlighted))
                    .foregroundColor(isEnabled ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
        .highlightOnHover(
            id: id,
            onHighlight: { isHighlighted = $0 },
            onTrigger: {}
        )
    }
    
//    private var dragGesture: some Gesture {
//        DragGesture(minimumDistance: 0, coordinateSpace: .local)
//            .onChanged { value in
//                value.location
//            }
//    }
    
    @ViewBuilder
    private func background(highlighted: Bool) -> some View {
        if highlighted {
            VisualEffectView.highlightedBackground
        }
    }
}
