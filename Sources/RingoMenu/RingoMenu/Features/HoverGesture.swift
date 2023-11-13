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
            .onReceive(hoverStateSubscriber, perform: onHighlight)
            .onReceive(hoverTriggerSubscriber, perform: onTrigger)
            .readFrame(in: .global, isEnable: coordinator.isHoverGestureEnable) { frame in
                coordinator.childrenGlobalFrame[id] = frame
            }
    }
    
    private var hoverStateSubscriber: some Publisher<Bool, Never> {
        coordinator.$hoveringID
            .map { id == $0 }
            .removeDuplicates()
    }
    
    private var hoverTriggerSubscriber: some Publisher<Void, Never> {
        coordinator.hoveringTriggerPublisher
            .filter { id == $0 }
            .map { _ in }
    }
}
