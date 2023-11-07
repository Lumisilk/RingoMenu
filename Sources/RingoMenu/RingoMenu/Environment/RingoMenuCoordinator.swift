//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI
import Combine

@MainActor
public class RingoMenuCoordinator: ObservableObject {
    
    let menuListName = UUID()
    
    // Feature: Focus on item
    @Published var focusOnItemID: UUID?
    @Published var focusMode: RingoMenuItemFocusMode = .removeOthers
    
    // Feature: Hover gesture
    @Published var isHoverGestureEnable = true
    var childrenFrame: [AnyHashable: CGRect] = [:]
    var hoveringIDPublisher = PassthroughSubject<AnyHashable?, Never>()
    var hoveringTriggerPublisher = PassthroughSubject<AnyHashable, Never>()
    
    private func hoveringViewID(_ location: CGPoint?) -> AnyHashable? {
        if let location,
           let id = childrenFrame.first(where: { id, frame in
               frame.contains(location)
           })?.key {
            return id
        } else {
            return nil
        }
    }
    func updateHoverGesture(_ location: CGPoint?) {
        guard isHoverGestureEnable else { return }
        hoveringIDPublisher.send(hoveringViewID(location))
    }
    
    func triggerHoverGesture(_ location: CGPoint?) {
        guard isHoverGestureEnable else { return }
        hoveringIDPublisher.send(nil)
        if let id = hoveringViewID(location) {
            hoveringTriggerPublisher.send(id)
        }
    }
}
