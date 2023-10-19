//
//  DemoViewController.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/11.
//

import UIKit
import SwiftUI
import RingoMenuSwiftUI

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
        let controller = RingoHostingController(sourceView: sender, rootView: AnyView(contentView))
        present(controller, animated: true)
    }
    
    @ViewBuilder
    private var contentView: some View {
        ScrollView {
            Button("Dismiss") { [weak self] in
                self?.dismiss(animated: true)
            }
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sollicitudin turpis et est gravida dapibus. Duis interdum sem vel felis venenatis, vitae rutrum leo faucibus. Cras elementum lorem metus, a lobortis risus mattis ac. Quisque nunc ante, pulvinar sed tortor vitae, tristique pellentesque urna. Morbi elementum elit vitae leo varius, a tincidunt mauris fermentum. Morbi auctor, eros vitae dapibus dapibus, dolor eros malesuada velit, et maximus ligula dui at libero. Curabitur tristique ac mi ut molestie. Nunc sollicitudin, ante sed condimentum aliquet, ipsum metus aliquet nunc, vitae dapibus libero sapien quis dolor. Mauris dictum consequat ipsum vel maximus. Donec quis mi ac velit ullamcorper maximus a id diam. Donec ornare venenatis accumsan. Integer non erat elit. Vestibulum pharetra sem in erat varius rutrum in vitae lorem. Suspendisse sed purus turpis.")
                .padding(.horizontal)
        }
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
