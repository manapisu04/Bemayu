//
//  EyebrowMenuBar.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

// 下部に表示するメニューバー
struct EyebrowMenuBar: View {
    @Binding var isShowEyebrowMenu: Bool
    @StateObject var viewModel: EyebrowSupportViewModel
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("barColor"))
                    VStack {
                        // 閉じるボタン
                        ZStack {
                            HStack {
                                Button {
                                    withAnimation {
                                        self.isShowEyebrowMenu = false
                                    }
                                    
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .padding(13.0)
                                }
                                
                                Spacer()
                            }
                            
                            ColorButtons(viewModel: viewModel, selectedColor: $viewModel.lineColor)
                        }
                        
                        // 眉毛ボタン
                        HStack {
                            ForEach(EyebrowImage.allCases) { eyebrowData in
                                EyebrowMenuButton(eyebrow: eyebrowData, viewModel: viewModel)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200.0)
            }
            .edgesIgnoringSafeArea(.bottom)
            .offset(x: 0, y: isShowEyebrowMenu ? 0 : geometry.size.height)
        }
    }
}

//struct EyebrowMenuBar_Previews: PreviewProvider {
//    static var previews: some View {
//        EyebrowMenuBar(isShowMenu: true)
//    }
//}
