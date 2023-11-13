//
//  RingoMenuCoordinator.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import Combine
import SwiftUI

@MainActor
public class RingoMenuCoordinator: ObservableObject {
    
    let menuListName = UUID()
    let blurGroupName = UUID().uuidString
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $headerFrames
            .debounce(for: DispatchQueue.main.minimumTolerance, scheduler: DispatchQueue.main)
            .sink { [unowned self] newFrames in
                self.update(headerFrames: newFrames)
            }
    }
    
    func reset() {
        transparentOtherItemID = nil
        childrenGlobalFrame = [:]
        headerFrames = [:]
    }
    
    // Feature: Focus on item
    @Published var transparentOtherItemID: AnyHashable?
    
    // Feature: Hover gesture
    @Published var isHoverGestureEnable = true
    var childrenGlobalFrame: [AnyHashable: CGRect] = [:]
    @CurrentValue var hoveringID: AnyHashable?
    var hoveringTriggerPublisher = PassthroughSubject<AnyHashable, Never>()
    
    private func hoveringViewID(_ location: CGPoint?) -> AnyHashable? {
        if let location,
           let id = childrenGlobalFrame.first(where: { id, frame in
               frame.contains(location)
           })?.key {
            return id
        } else {
            return nil
        }
    }
    
    func updateHoverGesture(_ location: CGPoint?) {
        guard isHoverGestureEnable else { return }
        hoveringID = hoveringViewID(location)
    }
    
    func triggerHoverGesture(_ location: CGPoint?) {
        guard isHoverGestureEnable else { return }
        hoveringID = nil
        if let id = hoveringViewID(location) {
            hoveringTriggerPublisher.send(id)
        }
    }
    
    // Feature: Pinned header
    @CurrentValue var headerFrames: [Namespace.ID: CGRect] = [:]
    @CurrentValue var headerOffsets: [Namespace.ID: CGFloat] = [:]
    
    private func update(headerFrames: [Namespace.ID: CGRect]) {
        var newHeaderOffsets: [Namespace.ID: CGFloat] = [:]
        defer { headerOffsets = newHeaderOffsets }

        let headerFramePairs = headerFrames
            .map { (id: $0.key, frame: $0.value) }
            .sorted { $0.frame.minY < $1.frame.minY }
            .adjacentPairsFromNil()

        for (previous, current) in headerFramePairs {
            if let previous,
               case let touchingDistance = current.frame.minY - previous.frame.height,
               touchingDistance < 0 {
                newHeaderOffsets[previous.id] = -previous.frame.minY + touchingDistance
            }

            if current.frame.minY < 0 {
                newHeaderOffsets[current.id] = -current.frame.minY
            } else {
                break
            }
        }
    }
}
