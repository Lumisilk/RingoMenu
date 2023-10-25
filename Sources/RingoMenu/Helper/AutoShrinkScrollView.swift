//
//  File.swift
//  
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

class InternalUIScrollView: UIScrollView {
    private let hostingController: UIHostingController<AnyView>
    private let contentView: UIView
    private var needCheckContentViewFrame = true
    
    fileprivate init(@ViewBuilder content: () -> some View) {
        hostingController = .init(rootView: content().eraseToAnyView())
        contentView = hostingController.view!
        
        super.init(frame: .zero)
        
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.backgroundColor = nil
        addSubview(contentView)
    }
    
    override var frame: CGRect {
        didSet {
            needCheckContentViewFrame = true
        }
    }

    override var intrinsicContentSize: CGSize {
        let width = contentView.sizeThatFits(UIView.layoutFittingExpandedSize).width
        let height = contentView.intrinsicContentSize.height
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayoutIfNeeded()
    }
    
    func updateContentView(_ content: some View) {
        hostingController.rootView = content.eraseToAnyView()
        needCheckContentViewFrame = true
        setNeedsLayout()
    }
    
    private func updateLayoutIfNeeded() {
        guard needCheckContentViewFrame else { return }
        defer { needCheckContentViewFrame = false }
        let selfSize = bounds.size
        let contentMaxWidth = contentView.sizeThatFits(UIView.layoutFittingExpandedSize).width
        let contentMinHeight = contentView.intrinsicContentSize.height
        let contentViewSize = CGSize(width: min(contentMaxWidth, selfSize.width), height: contentMinHeight)
        if contentView.frame.size != contentViewSize {
            contentView.frame = CGRect(origin: .zero, size: contentViewSize)
            contentSize = contentViewSize
            invalidateIntrinsicContentSize()
        }
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
        InternalUIScrollView {
            content.environment(\.self, context.environment)
        }
    }

    func updateUIView(_ uiView: InternalUIScrollView, context: Context) {
        uiView.updateContentView(
            content.environment(\.self, context.environment)
        )
    }
}

struct AutoShrinkScrollView_Preview: PreviewProvider {
    struct Example: View {
        @State private var count = 10
        
        var body: some View {
            VStack {
                AutoShrinkScrollView {
                    VStack {
                        Color.blue
                        ForEach(Array(0..<count), id: \.self) { i in
                            Text(i.description)
                                .padding()
                        }
                    }
                    .border(.green)
                }
                .border(.red)
                .frame(maxHeight: .infinity)
                
                Stepper("Row", value: $count, in: 1...20)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        Example()
    }
}
