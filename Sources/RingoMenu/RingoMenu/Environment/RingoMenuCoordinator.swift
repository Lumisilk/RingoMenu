//
//  RingoMenuCoordinator.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import Combine
import SwiftUI

@MainActor
class RingoMenuCoordinator: ObservableObject {
    
    let menuListName = UUID()
    let blurGroupName = UUID().uuidString
    
    var popoverCoordinator: RingoPopoverCoordinator?
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $headerFrames
            .debounce(for: DispatchQueue.main.minimumTolerance, scheduler: DispatchQueue.main)
            .sink { [unowned self] newFrames in
                self.update(headerFrames: newFrames)
            }
    }
    
    func reset() {
        transparentOtherItemEnable = false
        childrenGlobalFrame = [:]
        headerFrames = [:]
    }
    
    // MARK: Leading trailing alignment
    var reserveLeadingMarkArea = false
    var reserveTrailingImageArea = false
    var leadingMarkWidth: Double = 18
    var trailingImageWidth: Double = 30
    
    // MARK: Focus on item
    @Published var transparentOtherItemEnable = false
    
    // MARK: Hover gesture
    var isHoverGestureEnable = true
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
    
    func updateHoverGesture(_ location: CGPoint) {
        guard isHoverGestureEnable else { return }
        popoverCoordinator?.ringoContainer?.hoverGestureLocationChanged(location)
        hoveringID = hoveringViewID(location)
    }
    
    func triggerHoverGesture(_ location: CGPoint) {
        guard isHoverGestureEnable else { return }
        popoverCoordinator?.ringoContainer?.hoverGestureReleased()
        hoveringID = nil
        if let id = hoveringViewID(location) {
            hoveringTriggerPublisher.send(id)
        }
    }
    
    // MARK: Pinned header
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
