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
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("barColor"))
                    VStack {
                        // 閉じるボタン
                        HStack {
                            // FIXME: いったんぼたん。あとでスワイプしてとじるにしちゃおっかな！
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
                        
                        // 眉毛ボタン
                        HStack {
                            ForEach(1..<5) { _ in
                                EyebrowMenuButton(impression: .cute, title: "cute_h")
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
