//
//  UIMenuDemo.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/24.
//

import UIKit

final class UIMenuDemo: UIViewController {
    
    let simpleMenuButton = UIButton(configuration: .borderedTinted())
    let complexMenuButton = UIButton(configuration: .borderedTinted())
    let subMenuButton = UIButton(configuration: .borderedTinted())
    lazy var stack = UIStackView(arrangedSubviews: [simpleMenuButton, complexMenuButton, subMenuButton])
    let dragMenuButton = UIButton(configuration: .borderedTinted())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSimpleMenuButton()
        setupComplexButton()
        setupSubMenuButton()
        setupStack()
        setupDragMenuButton()
    }
    
    func setupSimpleMenuButton() {
        let elements: [UIMenuElement] = [
            UIAction(title: "Simple", handler: { _ in }),
            UIAction(title: "Title", subtitle: "Subtitle", handler: { _ in }),
            UIAction(title: "Title", subtitle: "Subtitle", handler: { _ in }),
            UIAction(title: "Simple with image", image: UIImage(systemName: "photo"), handler: { _ in }),
            UIAction(title: "Title", subtitle: "Subtitle", image: UIImage(systemName: "text.below.photo"), handler: { _ in }),
            UIAction(title: String(repeating: "Long", count: 20), subtitle: String(repeating: "Long", count: 20), handler: { _ in }),
            UIAction(title: "Inspect", attributes: .keepsMenuPresented, handler: { [view] _ in
                let subviews = view!.window!.subviews
                print("") // Breakpoint here to inspect the menu's view hierarchy.
            }),
        ]
        simpleMenuButton.menu = UIMenu(children: elements)
        simpleMenuButton.setTitle("Simple", for: .normal)
        simpleMenuButton.showsMenuAsPrimaryAction = true
    }
    
    func setupComplexButton() {
        let elements: [UIMenuElement] = [
            UIAction(title: "Selected", state: .on, handler: { _ in }),
            UIAction(title: "Multi-selected", subtitle: "Subtitle", state: .mixed, handler: { _ in }),
            UIAction(title: "Multi-selected Image", image: UIImage(systemName: "house.fill"), state: .mixed, handler: { _ in }),
            UIAction(title: "Destructive", subtitle: "Subtitle", image: UIImage(systemName: "pencil.and.scribble"), attributes: .destructive, state: .on, handler: { _ in }),
            UIAction(title: "Disabled", attributes: .disabled, handler: { _ in }),
            UIAction(title: "Destructive and Disabled", attributes: [.disabled, .destructive], handler: { _ in }),
            
            UIAction(title: "Inspect", attributes: .keepsMenuPresented, handler: { [view] _ in
                let subviews = view!.window!.subviews
                print("") // Breakpoint here to inspect the menu's view hierarchy.
            }),
        ]
        
        complexMenuButton.menu = UIMenu(preferredElementSize: .medium, children: elements)
        complexMenuButton.setTitle("Complex", for: .normal)
        complexMenuButton.showsMenuAsPrimaryAction = true
    }
    
    func setupSubMenuButton() {
        var children: [UIMenuElement] = [
            UIAction(title: "Inspect", attributes: .keepsMenuPresented, handler: { [view] _ in
                let subviews = view!.window!.subviews
                let backgroundBlur = subviews[3].subviews[0] as! UIVisualEffectView
                dump(backgroundBlur)
                print("") // Breakpoint here to inspect the menu's view hierarchy.
            }),
            UIMenu(title: "Inline menu", options: .displayInline, children: makeActions(10)),
            UIMenu(title: "Destructive menu", options: .destructive, children: makeActions(5)),
            UIMenu(title: "Singele selection menu", options: .singleSelection, children: makeActions(5)),
            UIMenu(title: "Second menu", children: makeActions(10))
        ]
        if #available(iOS 17, *) {
            children.append(
                UIMenu(title: "Palette menu", options: .displayAsPalette, children: makeActions(5))
            )
        }
        subMenuButton.menu = UIMenu(title: "SubMenu", children: children)
        subMenuButton.setTitle("SubMenu", for: .normal)
        subMenuButton.showsMenuAsPrimaryAction = true
    }
    
    func setupStack() {
        stack.axis = .horizontal
        stack.spacing = 32
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60)
        ])
    }
    
    func setupDragMenuButton() {
        dragMenuButton.menu = UIMenu(title: "Main Menu", children: makeActions(20))
        dragMenuButton.setTitle("Drag Button", for: .normal)
        dragMenuButton.showsMenuAsPrimaryAction = true
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(didDrapButton))
        dragMenuButton.addGestureRecognizer(dragGesture)
        
        dragMenuButton.sizeToFit()
        dragMenuButton.center.x = view.center.x
        dragMenuButton.center.y = view.center.y / 2
        view.addSubview(dragMenuButton)
    }
    
    @objc func didDrapButton(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view else { return }
        button.center = gesture.location(in: button.superview)
    }
    
    func makeActions(_ count: Int) -> [UIMenuElement] {
        (0..<count).map { i in
            UIAction(title: "Action \(i)", handler: { _ in })
        }
    }
}
