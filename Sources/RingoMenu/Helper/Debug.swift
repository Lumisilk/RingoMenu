//
//  Debug.swift
//
//
//  Created by Lumisilk on 2023/10/24.
//

import Foundation

private var debugMode = false

func ringoDebug(_ items: Any...) {
    if debugMode {
        for item in items {
            print(item, terminator: " ")
        }
        print("")
    }
}
