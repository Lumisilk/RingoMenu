//
//  GestureFallbackView.swift
//  
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit

class GestureFallbackView: UIView, UIGestureRecognizerDelegate {
    private var targetView: UIView
    private var action: () -> Void
    
    private let tapGesture = UITapGestureRecognizer()
    private let panGesture = UIPanGestureRecognizer()
    private let longPressGesture = UILongPressGestureRecognizer()
    
    init(targetView: UIView, action: @escaping () -> Void) {
        self.targetView = targetView
        self.action = action
        super.init(frame: .zero)
        
        tapGesture.delaysTouchesBegan = true
        panGesture.delaysTouchesBegan = true
        longPressGesture.delaysTouchesBegan = true
        
        tapGesture.delegate = self
        panGesture.delegate = self
        longPressGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(onAction))
        panGesture.addTarget(self, action: #selector(onAction))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let target = targetView.hitTest(point, with: event) else { return nil }
        if tapGesture.view == nil {
            target.addGestureRecognizer(tapGesture)
            target.addGestureRecognizer(panGesture)
            target.addGestureRecognizer(longPressGesture)
        }
        return target
    }
    
    @objc func onAction() {
        tapGesture.view?.removeGestureRecognizer(tapGesture)
        panGesture.view?.removeGestureRecognizer(panGesture)
        longPressGesture.view?.removeGestureRecognizer(longPressGesture)
        action()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === tapGesture || gestureRecognizer === longPressGesture {
            return otherGestureRecognizer !== panGesture
        }
        return false
    }
}
