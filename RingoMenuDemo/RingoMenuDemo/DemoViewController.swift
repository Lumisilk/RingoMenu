//
//  DemoViewController.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit
import SwiftUI
import RingoMenu

let buttonTitles: [String] = [
    "Button",
    "Button Title"
] + (0..<30).map { "Very very very long button title \($0)" }

final class DemoViewController: UITableViewController, UITextFieldDelegate {

    let systemMenuButton = UIButton(configuration: .borderedTinted())
    let ringoMenuButton = UIButton(configuration: .borderedTinted())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSystemMenuButton()
        setupRingoMenuButton()
        tableView.keyboardDismissMode = .onDrag
    }
    
    func setupSystemMenuButton() {
        let actions: [UIAction] = buttonTitles.map { UIAction(title: $0, handler: { _ in }) }
        systemMenuButton.showsMenuAsPrimaryAction = true
        systemMenuButton.menu = UIMenu(children: actions)
        systemMenuButton.setTitle("UIMenu", for: .normal)
        
        view.addSubview(systemMenuButton)
        systemMenuButton.center = .init(x: 30, y: 30)
        systemMenuButton.sizeToFit()
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(didDrapButton))
        systemMenuButton.addGestureRecognizer(dragGesture)
    }
    
    func setupRingoMenuButton() {
        view.addSubview(ringoMenuButton)
        ringoMenuButton.setTitle("Ringo Popover", for: .normal)
        ringoMenuButton.frame.origin = .init(x: 230, y: 30)
        ringoMenuButton.sizeToFit()
        ringoMenuButton.addTarget(self, action: #selector(presentRingo), for: .touchUpInside)
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(didDrapButton))
        ringoMenuButton.addGestureRecognizer(dragGesture)
    }
    
    @objc func presentRingo(_ sender: UIButton) {
        let controller = RingoHostingController(
            sourceView: sender,
            onDismiss: { print("RingoHostingController Dismissed.") },
            rootView: PopoverContent(
                dismissAction: {[weak self] in
                    self?.dismiss(animated: true)
                }
            )
        )
        present(controller, animated: true)
    }
    
    @objc func didDrapButton(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view else { return }
        button.center = gesture.location(in: button.superview)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        if indexPath.row == 0 {
            let textField = UITextField()
            textField.delegate = self
            textField.returnKeyType = .done
            textField.frame = cell.contentView.bounds
            textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(textField)
            return cell
        } else {
            var config = cell.defaultContentConfiguration()
            config.text = String(indexPath.row)
            cell.contentConfiguration = config
            return cell
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

#Preview {
    UIViewControllerAdaptor {
        DemoViewController()
    }
}
