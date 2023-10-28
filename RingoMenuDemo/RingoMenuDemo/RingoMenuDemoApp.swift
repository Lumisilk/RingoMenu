//
//  RingoMenuDemoApp.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/11.
//

import SwiftUI

@main
struct RingoMenuDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section("RingoMenu") {
                        PlainRingoMenuDemo()
                        
                        NavigationLink("Custom Item Example") {
                            FontSizeStepperDemo()
                        }
                    }
                    .headerProminence(.increased)
                    
                    NavigationLink("UIMenu") {
                        UIViewControllerAdaptor {
                            UIMenuDemo()
                        }
                    }
                }
                .navigationTitle(Text("Ringo Menu"))
            }
        }
    }
}
