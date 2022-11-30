//
//  MenuBar.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

// 顔スキャンか、Eyebrowかを選択できる
struct MainMenuBar: View {
    // 眉位置をとるための画面にうつる時に使おうかな？
    @Binding var shouldScanningFace: Bool
    // 眉の画面用
    @Binding var isShowEyebrowMenu: Bool
    
    @Binding var test: Bool
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("barColor"))
                        .frame(width: .infinity)
                        .frame(height: 100.0)
                    
                    HStack {
                        Button {
                            // FIXME: 眉の画面に遷移
                            withAnimation {
                                self.shouldScanningFace = true
                            }
                        } label: {
                            MainMenuButton(systemName: "faceid", label: "Face")
                        }
                        
                        Spacer()
                            .frame(width: 100.0)
                        
                        Button {
                            // 眉のパターンを表示
                            withAnimation {
                                self.isShowEyebrowMenu = true
                            }
                        } label: {
                            MainMenuButton(systemName: "pencil", label: "MakeUp")
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .offset(x: 0, y: shouldScanningFace ? geometry.size.height : 0)
        }
    }
}


//
//struct MainMenuBar_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMenuBar()
//    }
//}
