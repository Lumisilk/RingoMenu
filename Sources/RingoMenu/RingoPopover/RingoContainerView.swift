//
//  RingoContainerView.swift
//
//
//  Created by Lumisilk on 2023/11/07.
//

import UIKit

final class RingoContainerView: UIView {
    
    private let cornerRadius: CGFloat = 13
    
    private let backgroundView: UIView?
    
    private let shadowView = ShadowView()
    
    private var contentView: UIView?
    
    init(backgroundView: UIView? = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))) {
        self.backgroundView = backgroundView
        super.init(frame: .zero)
        
        // Background
        backgroundColor = nil
        if let backgroundView {
            backgroundView.frame = bounds
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.clipsToBounds = true
            backgroundView.layer.cornerRadius = cornerRadius
            backgroundView.layer.cornerCurve = .circular
            addSubview(backgroundView)
        }
        
        // Shadow
        shadowView.bounds.size = bounds.size + CGSize(width: 300, height: 300)
        shadowView.center = center
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(shadowView)
    }
    
    func setupContentView(_ contentView: UIView) {
        self.contentView?.removeFromSuperview()
        self.contentView = contentView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.cornerCurve = .circular
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
