//
//  RingoMenuPlainButtonMediumLabel.swift
//
//
//  Created by Lumisilk on 2023/10/26.
//

import SwiftUI

struct RingoMenuPlainButtonMediumLabel: View {
    let title: String
    let image: Image?
    
    var body: some View {
        VStack(spacing: 4) {
            if let image {
                image
            }
            Text(title)
                .lineLimit(2)
        }
        .font(.footnote)
        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RingoMenuPlainButtonMediumLabel(title: "Title", image: Image(systemName: "house"))
        .border(Color.black)
}
