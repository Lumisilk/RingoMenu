//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/29.
//

import SwiftUI
import SwiftUIPresent

public class RingoMenuController: UIHostingController<AnyView> {
    
    private let menuCoordinator = RingoMenuCoordinator()
    
    private let ringoPopover: RingoPopover
    private let coordinator = RingoPopoverCoordinator()
    private var isPresented: Binding<Bool>?
    
    // For SwiftUIPresent
    init(configuration: PresentationConfiguration) {
        self.isPresented = configuration.isPresented
        let config = RingoPopoverConfiguration()
        ringoPopover = RingoPopover(sourceView: configuration.anchorView, config: config)
        
        super.init(
            rootView: configuration.content
                .environment(\.ringoPopoverCoordinator, coordinator)
                .eraseToAnyView()
        )
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
        ringoPopover.ringoPopoverDelegate = self
    }
    
    func update(configuration: PresentationConfiguration) {
        isPresented = configuration.isPresented
        rootView = configuration.content
            .environment(\.ringoPopoverCoordinator, coordinator)
            .eraseToAnyView()
    }
    
    // For UIkit
    public init(
        sourceView: UIView,
        option: RingoMenuOption = RingoMenuOption(),
        @ViewBuilder menuList: () -> some View
    ) {
        let config = RingoPopoverConfiguration()
        ringoPopover = RingoPopover(sourceView: sourceView, config: config)
        
        super.init(
            rootView: menuList()
                .environmentObject(menuCoordinator)
                .environment(\.ringoPopoverCoordinator, coordinator)
                .environment(\.ringoMenuOption, option)
                .eraseToAnyView()
        )
        
        modalPresentationStyle = .custom
        transitioningDelegate = ringoPopover
        ringoPopover.ringoPopoverDelegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
        coordinator.ringoPresenter = presentationController as? RingoPresenter
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
    }
}

// SwiftUIPresent Protocol
struct RingoMenuPresentationStyle: PresentationStyle {
    func makeHostingController(_ configuration: PresentationConfiguration) -> RingoMenuController {
        RingoMenuController(configuration: configuration)
    }
    
    func update(_ hostingController: RingoMenuController, configuration: PresentationConfiguration) {
        hostingController.update(configuration: configuration)
    }
}
