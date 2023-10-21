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
        
        setContentHuggingPriority(.defaultHigh, for: .vertical)
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
            contentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor)
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
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> InternalUIScrollView {
        return InternalUIScrollView {
            content.environment(\.self, context.environment)
        }
    }

    func updateUIView(_ uiView: InternalUIScrollView, context: Context) {
        uiView.hostingController.rootView = AnyView(content.environment(\.self, context.environment))
        uiView.hostingController.view.invalidateIntrinsicContentSize()
    }
}

struct AutoShrinkScrollView_Preview: PreviewProvider {
    struct Example: View {
        @State private var count = 5
        
        var body: some View {
            AutoShrinkScrollView {
                VStack {
                    Stepper("", value: $count)
                    ForEach(Array(0..<count), id: \.self) { i in
                        Text(i.description)
                    }
                }
                .border(.blue)
            }
            .border(.red)
        }
    }
    
    static var previews: some View {
        Example()
    }
}
