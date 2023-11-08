//
//  HoverGesture.swift
//
//
//  Created by Lumisilk on 2023/11/02.
//

import Combine
import SwiftUI

struct HoverGestureModifier: ViewModifier {
    @EnvironmentObject private var coordinator: RingoMenuCoordinator
    
    let id: AnyHashable
    let onHighlight: (Bool) -> Void
    let onTrigger: () -> Void
    
    func body(content: Content) -> some View {
        content
            .backport.background {
                if coordinator.isHoverGestureEnable {
                    GeometryReader { geo in
                        let frame = geo.frame(in: .global)
                        Color.clear
                            .onAppear { updateFrame(frame) }
                            .onChange(of: frame, perform: updateFrame)
                    }
                    .hidden()
                }
            }
            .onReceive(hoverStateSubscriber, perform: onHighlight)
            .onReceive(hoverTriggerSubscriber, perform: onTrigger)
    }
    
    private var hoverStateSubscriber: some Publisher<Bool, Never> {
        coordinator.hoveringIDPublisher
            .map { id == $0 }
            .removeDuplicates()
    }
    
    private var hoverTriggerSubscriber: some Publisher<Void, Never> {
        coordinator.hoveringTriggerPublisher
            .filter { id == $0 }
            .map { _ in () }
    }
    
    private func updateFrame(_ frame: CGRect) {
        coordinator.childrenGlobalFrame[id] = frame
    }
}

extension View {
    func highlightOnHover(
        id: AnyHashable,
        onHighlight: @escaping (Bool) -> Void,
        onTrigger: @escaping () -> Void
    ) -> some View {
        modifier(HoverGestureModifier(id: id, onHighlight: onHighlight, onTrigger: onTrigger))
    }
}
