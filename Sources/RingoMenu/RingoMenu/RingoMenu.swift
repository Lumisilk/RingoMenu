//
//  SwiftUIView.swift
//  
//
//  Created by Lumisilk on 2023/10/28.
//

import SwiftUI

private class RingoMenuUIButton: UIButton {
    
    var labelHostingController: UIHostingController<AnyView>
    var onHover: (CGPoint) -> Void
    var onPresent: () -> Void
    var onRelease: (CGPoint) -> Void
    
    init(
        @ViewBuilder label: () -> some View,
        onHover: @escaping (CGPoint) -> Void,
        onPresent: @escaping () -> Void,
        onRelease: @escaping (CGPoint) -> Void
    ) {
        labelHostingController = .init(rootView: label().eraseToAnyView())
        self.onHover = onHover
        self.onPresent = onPresent
        self.onRelease = onRelease
        super.init(frame: .zero)
        
        let view = labelHostingController.view!
        view.backgroundColor = nil
        view.isUserInteractionEnabled = false
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(view)
        translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onGestureChange))
        longPressGesture.minimumPressDuration = 0.3
        addTarget(self, action: #selector(present), for: .touchUpInside)
        addGestureRecognizer(longPressGesture)
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.layer.opacity = self.isHighlighted ? 0.2: 1
            }
        }
    }
    
    @objc private func onGestureChange(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            onPresent()
        case .changed:
            onHover(gesture.location(in: nil))
        case .recognized:
            onRelease(gesture.location(in: nil))
        default:
            break
        }
    }
    
    @objc private func present() {
        onPresent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private struct RingoMenuUIButtonBridge<Label: View>: UIViewRepresentable {
    @ViewBuilder let label: () -> Label
    let onHover: (CGPoint) -> Void
    let onPresent: () -> Void
    let onRelease: (CGPoint) -> Void
    
    func makeUIView(context: Context) -> RingoMenuUIButton {
        RingoMenuUIButton(
            label: { label().environment(\.self, context.environment) },
            onHover: onHover,
            onPresent: onPresent,
            onRelease: onRelease
        )
    }
    
    func updateUIView(_ uiView: RingoMenuUIButton, context: Context) {
        uiView.labelHostingController.rootView = label()
            .environment(\.self, context.environment)
            .eraseToAnyView()
        uiView.onHover = onHover
        uiView.onPresent = onPresent
        uiView.onRelease = onRelease
    }
    
    @available(iOS 16, *)
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: RingoMenuUIButton, context: Context) -> CGSize? {
        uiView.labelHostingController.view.systemLayoutSizeFitting(
            proposal.cgSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    // Fallback to this method on iOS 15 and below
    func _overrideSizeThatFits(_ size: inout CoreFoundation.CGSize, in proposedSize: SwiftUI._ProposedSize, uiView: Self.UIViewType) {
        size = uiView.labelHostingController.view.systemLayoutSizeFitting(
            proposedSize.cgSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

public struct RingoMenu<Content: View, Footer: View, Label: View>: View {
    
    @Environment(\.ringoMenuOption) private var ringoMenuOption
    
    @StateObject internal var menuCoordinator = RingoMenuCoordinator()
    
    @State private var defaultIsPresented = false
    
    var explicitIsPresented: Binding<Bool>?
    let menuList: RingoMenuList<Content, Footer>
    let label: Label
    
    public init(
        isPresented: Binding<Bool>? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer,
        @ViewBuilder label: () -> Label
    ) {
        self.explicitIsPresented = isPresented
        self.menuList = RingoMenuList(content: content, footer: footer)
        self.label = label()
    }
    
    private var isPresented: Binding<Bool> {
        explicitIsPresented ?? $defaultIsPresented
    }
    
    public var body: some View {
        RingoMenuUIButtonBridge {
            label
        } onHover: { location in
            menuCoordinator.updateHoverGesture(location)
        } onPresent: {
            presentIfNeeded()
        } onRelease: { location in
            menuCoordinator.triggerHoverGesture(location)
        }
        .present(
            isPresented: isPresented,
            style: RingoMenuPresentationStyle(menuCoordinator: menuCoordinator)
        ) {
            menuList
                .simultaneousGesture(hoverGestureIfNeeded)
                .environment(\.ringoMenuOption, ringoMenuOption)
        }
    }
    
    private var hoverGestureIfNeeded: some Gesture {
        menuCoordinator.isHoverGestureEnable ?
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                menuCoordinator.updateHoverGesture(value.location)
            }
            .onEnded { value in
                menuCoordinator.triggerHoverGesture(value.location)
            }
        : nil
    }
    
    private func presentIfNeeded() {
        if isPresented.wrappedValue == false {
            isPresented.wrappedValue = true
        }
    }
}

#Preview {
    RingoMenuPreview()
}
