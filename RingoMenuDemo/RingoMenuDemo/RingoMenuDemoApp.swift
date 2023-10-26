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
            TabView {
                DemoSwiftUIView()
                    .tabItem { Text("SwiftUI") }
                
                UIViewControllerAdaptor {
                    UIMenuDemo()
                }
                .tabItem { Text("UImenu") }
                
                UIViewControllerAdaptor {
                    DemoViewController(style: .plain)
                }
                .tabItem { Text("UIKit") }
                
            }
        }
    }
}
