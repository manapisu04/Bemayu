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
    
    @ObservedObject var viewModel: EyebrowSupportViewModel
    @Binding var test: Bool
    
    init(impression: Impression, title: String, viewModel: EyebrowSupportViewModel, test: Binding<Bool>) {
        self.impression = impression
        self.title = title
        self.viewModel = viewModel
        switch(impression) {
        case .cute:
            self.labelColor = SwiftUI.Color("cuteColor")
        case .cool:
            self.labelColor = SwiftUI.Color("coolColor")
        case .natural:
            self.labelColor = SwiftUI.Color("naturalColor")
        }
        self._test = test
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
        .gesture(
            TapGesture()
                .onEnded { _ in
                    viewModel.changeImage(name: EyebrowsType.test2)
                    test.toggle()
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
