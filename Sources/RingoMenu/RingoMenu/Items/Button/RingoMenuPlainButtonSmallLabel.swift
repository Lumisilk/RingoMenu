//
//  RingoMenuPlainButtonSmallLabel.swift
//
//
//  Created by Lumisilk on 2023/10/26.
//

import SwiftUI

struct RingoMenuPlainButtonSmallLabel: View {
    let title: String
    let image: Image?
    
    var body: some View {
        Group {
            if let image {
                image
            } else {
                Text(title)
                    .lineLimit(1)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RingoMenuPlainButtonSmallLabel(title: "Title", image: Image(systemName: "house"))
        .border(Color.black)
}
