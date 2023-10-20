//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

class InternalUIScrollView: UIScrollView {
    let hostingController: UIHostingController<AnyView>

    fileprivate init(@ViewBuilder content: () -> some View) {
        self.hostingController = .init(rootView: AnyView(content()))
        super.init(frame: .zero)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        let contentView = hostingController.view!
        contentView.backgroundColor = nil
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor)
        ])
    }
    
    override var contentSize: CGSize {
        didSet { invalidateIntrinsicContentSize() }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct AutoShrinkScrollView<Content: View>: UIViewRepresentable {
    
    @ViewBuilder let content: () -> Content

    func makeUIView(context: Context) -> InternalUIScrollView {
        InternalUIScrollView {
            content().environment(\.self, context.environment)
        }
    }

    func updateUIView(_ uiView: InternalUIScrollView, context: Context) {
        uiView.hostingController.rootView = AnyView(content().environment(\.self, context.environment))
    }
}
