//
//  EyebrowMenuButton.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

// 眉の写真とイメージネーム
struct EyebrowMenuButton: View {
    let eyebrow: Eyebrow
    let labelColor: Color
    
    @ObservedObject var viewModel: EyebrowSupportViewModel
    
    init(eyebrow: Eyebrow, viewModel: EyebrowSupportViewModel) {
        self.eyebrow = eyebrow
        self.viewModel = viewModel
        switch(eyebrow.type) {
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
            Image(eyebrow.buttonImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
    
            ZStack {
                Rectangle()
                    .foregroundColor(labelColor)
                    .frame(width: 80.0, height: 30.0)
                
                Text(eyebrow.tag)
                    .foregroundColor(.white)
            }
        }
        .background(Color.white)
        .cornerRadius(4.0)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    viewModel.changeImage(left: eyebrow.leftImage, right: eyebrow.rightImage)
                    viewModel.tappedImage = true
                }
        )
    }
}

//struct EyebrowMenuButton_Previews: PreviewProvider {
//    static var previews: some View {
//        EyebrowMenuButton(impression: .cute, title: "cute_h")
//    }
//}

enum Impression {
    case cute
    case cool
    case natural
}
