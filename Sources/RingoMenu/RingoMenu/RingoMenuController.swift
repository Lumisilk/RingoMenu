//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/29.
//

import SwiftUI
import SwiftUIPresent

@MainActor
public class RingoMenuController: UIHostingController<AnyView> {
    
    private let menuCoordinator: RingoMenuCoordinator
    
    private let ringoPopover: RingoPopover
    private let ringoPopoverCoordinator = RingoPopoverCoordinator()
    private var isPresented: Binding<Bool>?
    
    // For SwiftUIPresent
    init(menuCoordinator: RingoMenuCoordinator?, configuration: PresentationConfiguration) {
        self.menuCoordinator = menuCoordinator ?? RingoMenuCoordinator()
        self.isPresented = configuration.isPresented
        let config = RingoPopoverConfiguration(backgroundView: UIVisualEffectView.menuBackground(groupName: self.menuCoordinator.blurGroupName))
        ringoPopover = RingoPopover(sourceView: configuration.anchorView, config: config)
        
        super.init(
            rootView: configuration.content
                .environmentObject(self.menuCoordinator)
                .environment(\.ringoPopoverCoordinator, ringoPopoverCoordinator)
                .eraseToAnyView()
        )
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
        ringoPopover.ringoPopoverDelegate = self
    }
    
    func update(configuration: PresentationConfiguration) {
        isPresented = configuration.isPresented
        rootView = configuration.content
            .environmentObject(menuCoordinator)
            .environment(\.ringoPopoverCoordinator, ringoPopoverCoordinator)
            .eraseToAnyView()
    }
    
    // For UIkit
    public init(
        sourceView: UIView,
        option: RingoMenuOption = RingoMenuOption(),
        @ViewBuilder menuList: () -> some View
    ) {
        menuCoordinator = RingoMenuCoordinator()
        let config = RingoPopoverConfiguration(backgroundView: UIVisualEffectView.menuBackground(groupName: menuCoordinator.blurGroupName))
        ringoPopover = RingoPopover(sourceView: sourceView, config: config)
        
        super.init(
            rootView: menuList()
                .environmentObject(menuCoordinator)
                .environment(\.ringoPopoverCoordinator, ringoPopoverCoordinator)
                .environment(\.ringoMenuOption, option)
                .eraseToAnyView()
        )
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
        preferredContentSize = .init(width: 250, height: 650)
        ringoPopover.ringoPopoverDelegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
        ringoPopoverCoordinator.ringoPresenter = presentationController as? RingoPresenter
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSizeBasedOnRingoPopover()
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RingoMenuController: RingoPopoverDelegate {
    public func ringoPopoverDidDismissed() {
        isPresented?.wrappedValue = false
        menuCoordinator.reset()
    }
}

// SwiftUIPresent Protocol
struct RingoMenuPresentationStyle: PresentationStyle {
    
    let menuCoordinator: RingoMenuCoordinator
    
    func makeHostingController(_ configuration: PresentationConfiguration) -> RingoMenuController {
        RingoMenuController(menuCoordinator: menuCoordinator, configuration: configuration)
    }
    
    func update(_ hostingController: RingoMenuController, configuration: PresentationConfiguration) {
        hostingController.update(configuration: configuration)
    }
}
