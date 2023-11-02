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
