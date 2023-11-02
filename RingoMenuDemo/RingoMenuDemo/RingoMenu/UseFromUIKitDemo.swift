//
//  UseFromUIKitDemo.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/29.
//

import UIKit
import SwiftUI
import RingoMenu

class UseFromUIKitDemo: UIViewController {
    
    let menuButton = UIButton(configuration: .bordered())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.setTitle("Ringo Menu", for: .normal)
        menuButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presentRingoMenu()
        }) , for: .touchUpInside)
        view.addSubview(menuButton)
        menuButton.sizeToFit()
        menuButton.center = view.center
    }
    
    private func presentRingoMenu() {
        let menuController = RingoMenuController(sourceView: menuButton) {
            RingoMenuList {
                ForEach(0..<6) { i in
                    RingoMenuButton(title: "Title \(i)", action: {})
                }
            }
        }
        present(menuController, animated: true)
    }
}
