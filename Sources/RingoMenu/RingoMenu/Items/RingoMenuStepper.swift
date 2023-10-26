//
//  RingoMenuStepper.swift
//
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI

public struct RingoMenuStepper<
    V: Strideable,
    ContentLabel: View,
    DecrementLabel: View,
    IncrementLabel: View
>: View {
    
    @State private var focused = false
    
    @Binding var value: V
    var bounds: ClosedRange<V>
    var step: V.Stride = 1
    
    var contentLabel: (V) -> ContentLabel
    var decrementLabel: DecrementLabel
    var incrementLabel: IncrementLabel
    
    public var body: some View {
        HStack(spacing: 0) {
            Button {
                value = max(bounds.lowerBound, value.advanced(by: -step))
                focused = true
            } label: {
                decrementLabel
            }
            .disabled(value <= bounds.lowerBound)
            
            Divider()
            
            contentLabel(value)
                .onTapGesture {
                    focused = false
                }
            
            Divider()
            
            Button {
                value = min(bounds.upperBound, value.advanced(by: step))
                focused = true
            } label: {
                incrementLabel
            }
            .disabled(value >= bounds.upperBound)
        }
        .buttonStyle(RingoMenuButtonStyle())
        .fixedSize(horizontal: false, vertical: true)
//        .focusOnThisItem(isOn: $focused, by: .removeOthers)
    }
}

public struct RingoMenuStepperTextContentLabel: View {
    let text: String
    
    public var body: some View {
        Text(text)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
    }
}

public struct RingoMenuStepperTextStepLabel: View {
    let isDecrement: Bool
    let text: String
    
    public var body: some View {
        Text(text)
            .font(isDecrement ? .footnote : .body)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
    }
}

public extension RingoMenuStepper where ContentLabel == RingoMenuStepperTextContentLabel, DecrementLabel ==  RingoMenuStepperTextStepLabel, IncrementLabel ==  RingoMenuStepperTextStepLabel {
    init(
        value: Binding<V>,
        bounds: ClosedRange<V>,
        step: V.Stride = 1,
        contentText: @escaping (V) -> String,
        decrementText: String,
        incrementText: String
    ) {
        self.init(
            value: value,
            bounds: bounds,
            step: step,
            contentLabel: { RingoMenuStepperTextContentLabel(text: contentText($0)) } ,
            decrementLabel: RingoMenuStepperTextStepLabel(isDecrement: true, text: decrementText),
            incrementLabel: RingoMenuStepperTextStepLabel(isDecrement: false, text: incrementText)
        )
    }
}

#Preview {
    RingoMenuStepper(
        value: .constant(100),
        bounds: 50...150,
        contentText: { "\($0.description)%" },
        decrementText: "あ",
        incrementText: "あ"
    )
    .border(Color.red)
}
