//
//  UIViewControllerAdaptor.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/11.
//

import SwiftUI

struct UIViewControllerAdaptor<UIViewControllerType: UIViewController>: UIViewControllerRepresentable {
    let content: () -> UIViewControllerType
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        content()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
