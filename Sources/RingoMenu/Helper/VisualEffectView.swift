//
//  VisualEffectView.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import UIKit
import SwiftUI

public struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    var backgroundColor: UIColor? = nil
    var groupName: String?
    
    public init(effect: UIVisualEffect, backgroundColor: UIColor? = nil, groupName: String? = nil) {
        self.effect = effect
        self.backgroundColor = backgroundColor
        self.groupName = groupName
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: effect)
        view.contentView.backgroundColor = backgroundColor
        if let groupName {
            view.setGroupName(groupName)
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
        uiView.contentView.backgroundColor = backgroundColor
    }
}

extension VisualEffectView {
    static func menuBackground(groupName: String? = nil) -> VisualEffectView {
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial), groupName: groupName)
    }
    
    static var highlightedBackground: VisualEffectView {
        VisualEffectView(
            effect: UIVibrancyEffect(
                blurEffect: UIBlurEffect(style: .systemMaterial),
                style: UIVibrancyEffectStyle.tertiaryFill
            ),
            backgroundColor: UIColor.white
        )
    }
}
