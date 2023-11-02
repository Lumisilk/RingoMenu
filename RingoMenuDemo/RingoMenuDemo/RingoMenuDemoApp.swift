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
                    Section {
                        PlainRingoMenuDemo()
                        
                        NavigationLink("Custom Item Example") {
                            FontSizeStepperDemo()
                        }
                        
                        NavigationLink("Use from UIKit") {
                            UIViewControllerAdaptor {
                                UseFromUIKitDemo()
                            }
                        }
                    }
                    
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
