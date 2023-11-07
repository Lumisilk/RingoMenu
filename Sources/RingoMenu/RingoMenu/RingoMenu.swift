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
    
    init(@ViewBuilder label: () -> some View, onHover: @escaping (CGPoint) -> Void, onPresent: @escaping () -> Void) {
        labelHostingController = .init(rootView: label().eraseToAnyView())
        self.onHover = onHover
        self.onPresent = onPresent
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
    
//    override var intrinsicContentSize: CGSize {
//        systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
//    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.layer.opacity = self.isHighlighted ? 0.2: 1
            }
        }
    }
    
    @objc private func onGestureChange(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .possible:
            print("possible")
        case .began:
            onPresent()
        case .changed:
            onHover(gesture.location(in: nil))
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        case .recognized:
            print("recognized")
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
    
    func makeUIView(context: Context) -> RingoMenuUIButton {
        RingoMenuUIButton(
            label: { label().environment(\.self, context.environment) },
            onHover: onHover,
            onPresent: onPresent
        )
    }
    
    func updateUIView(_ uiView: RingoMenuUIButton, context: Context) {
        uiView.labelHostingController.rootView = label().environment(\.self, context.environment).eraseToAnyView()
        uiView.onHover = onHover
        uiView.onPresent = onPresent
    }
    
    @available(iOS 16, *)
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: RingoMenuUIButton, context: Context) -> CGSize? {
        uiView.systemLayoutSizeFitting(proposal.cgSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultHigh)
    }
}



public struct RingoMenu<Content: View, Label: View>: View {
    
    @Environment(\.ringoMenuOption) private var ringoMenuOption
    
    @StateObject internal var coordinator = RingoMenuCoordinator()
    
    @State private var internalIsPresented: Bool = false
    
    var explicitIsPresented: Binding<Bool>?
    let menuList: RingoMenuList<Content>
    let label: Label
    
    public init(
        isPresented: Binding<Bool>? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.explicitIsPresented = isPresented
        self.menuList = RingoMenuList(content: content)
        self.label = label()
    }
    
    private var isPresented: Binding<Bool> {
        explicitIsPresented ?? $internalIsPresented
    }
    
    public var body: some View {
        RingoMenuUIButtonBridge {
            label
        } onHover: { location in
            coordinator.updateHoverGesture(location)
        } onPresent: {
            presentIfNeeded()
        }
        .present(isPresented: isPresented, style: RingoMenuPresentationStyle()) {
            menuList
                .environment(\.ringoMenuOption, ringoMenuOption)
                .environmentObject(coordinator)
                .simultaneousGesture(hoverGestureIfNeeded)
        }
    }
    
    private var hoverGestureIfNeeded: some Gesture {
        let drag = DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                coordinator.updateHoverGesture(value.location)
            }
            .onEnded { value in
                coordinator.triggerHoverGesture(value.location)
            }
        return coordinator.isHoverGestureEnable ? drag : nil
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
