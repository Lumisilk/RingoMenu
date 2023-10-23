//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public class RingoMenuCoordinator: ObservableObject {
    @Published var focusOnItemID: UUID?
    @Published var focusMode: RingoMenuItemFocusMode = .removeOthers
}

//private struct RingoMenuCoordinatorEnvironmentKey: EnvironmentKey {
//    static let defaultValue = RingoMenuCoordinator()
//}
//
//extension EnvironmentValues {
//    var ringoMenuCoordinator: RingoMenuCoordinator {
//        get { self[RingoMenuCoordinatorEnvironmentKey.self] }
//        set { self[RingoMenuCoordinatorEnvironmentKey.self] = newValue }
//    }
//}
