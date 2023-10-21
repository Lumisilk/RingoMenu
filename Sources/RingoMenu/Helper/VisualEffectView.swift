//
//  VisualEffectView.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import UIKit
import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    var backgroundColor: UIColor? = nil
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: effect)
        view.contentView.backgroundColor = backgroundColor
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
        uiView.contentView.backgroundColor = backgroundColor
    }
}
