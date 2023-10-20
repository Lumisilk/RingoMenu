//
//  DemoSwiftUIView.swift
//  RingoMenuDemo
//
//  Created by Lumisilk on 2023/10/20.
//

import SwiftUI
import RingoMenuSwiftUI

struct DemoSwiftUIView: View {
    
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Button("Present") {
                isPresented = true
            }
            .present(isPresented: $isPresented, style: .ringoPopover) {
                PopoverContent { isPresented = false }
            }
            
            TextField("", text: .constant("Fixed"))
        }
    }
}

struct PopoverContent: View {
    
    @State private var isExpanded = true
    var dismissAction: () -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                Button("Dismiss", action: dismissAction)
                Button("Expand") {
                    isExpanded.toggle()
                }
                Text("Some")
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sollicitudin turpis et est gravida dapibus. Duis interdum sem vel felis venenatis, vitae rutrum leo faucibus. Cras elementum lorem metus, a lobortis risus mattis ac. Quisque nunc ante, pulvinar sed tortor vitae, tristique pellentesque urna. Morbi elementum elit vitae leo varius, a tincidunt mauris fermentum. Morbi auctor, eros vitae dapibus dapibus, dolor eros malesuada velit, et maximus ligula dui at libero. Curabitur tristique ac mi ut molestie. Nunc sollicitudin, ante sed condimentum aliquet, ipsum metus aliquet nunc, vitae dapibus libero sapien quis dolor. Mauris dictum consequat ipsum vel maximus. Donec quis mi ac velit ullamcorper maximus a id diam. Donec ornare venenatis accumsan. Integer non erat elit. Vestibulum pharetra sem in erat varius rutrum in vitae lorem. Suspendisse sed purus turpis.")
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: isExpanded ? .infinity : 200, maxHeight: isExpanded ? .infinity : 200)
        .animation(.default, value: isExpanded)
    }
}

#Preview {
    DemoSwiftUIView()
}
