//
//  EyebrowMenuButton.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

// 眉の写真とイメージネーム
struct EyebrowMenuButton: View {
    let eyebrow: EyebrowImage
    
    @ObservedObject var viewModel: EyebrowSupportViewModel
//    @Binding var selectedType: EyebrowImage
    
    var body: some View {
        VStack {
            Image(eyebrow.buttonImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
    
            ZStack {
                Rectangle()
                    .foregroundColor(eyebrow.type.color)
                    .frame(width: 80.0, height: 30.0)
                
                Text(eyebrow.tag)
                    .foregroundColor(.white)
            }
        }
        .background(Color.white)
        .cornerRadius(4.0)
        .overlay(
            ZStack {
                if viewModel.hasTapped, eyebrow.image == viewModel.eyebrowImage {
                    Color.gray
                        .opacity(0.7)
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .bold()
                        .foregroundColor(.white)
                } 
            }
            
        )
        .gesture(
            TapGesture()
                .onEnded { _ in
                    viewModel.tappedImage(eyebrowImage: eyebrow)
                    viewModel.tappedImage = true
                    viewModel.hasTapped = true
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
    
    var color: Color {
        switch self {
        case .cute:
            return SwiftUI.Color("cuteColor")
        case .cool:
            return SwiftUI.Color("coolColor")
        case .natural:
            return SwiftUI.Color("naturalColor")
        }
    }
}
