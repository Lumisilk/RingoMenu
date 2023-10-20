//
//  UIViewAdapter.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import UIKit
import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
