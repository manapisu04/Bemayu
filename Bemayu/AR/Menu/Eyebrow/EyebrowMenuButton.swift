//
//  EyebrowMenuButton.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

// 眉の写真とイメージネーム
struct EyebrowMenuButton: View {
    let impression: Impression
    let title: String
    let labelColor: Color
    
    init(impression: Impression, title: String) {
        self.impression = impression
        self.title = title
        switch(impression) {
        case .cute:
            self.labelColor = SwiftUI.Color("cuteColor")
        case .cool:
            self.labelColor = SwiftUI.Color("coolColor")
        case .natural:
            self.labelColor = SwiftUI.Color("naturalColor")
        }
    }
    
    var body: some View {
        VStack {
            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
    
            ZStack {
                Rectangle()
                    .foregroundColor(labelColor)
                    .frame(width: 80.0, height: 30.0)
                
                Text(title)
                    .foregroundColor(.white)
            }
        }
        .background(Color.white)
        .cornerRadius(4.0)
    }
}

struct EyebrowMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        EyebrowMenuButton(impression: .cute, title: "cute_h")
    }
}

enum Impression {
    case cute
    case cool
    case natural
}
