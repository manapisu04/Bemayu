//
//  MakeupView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/07.
//

import SwiftUI

struct MakeupView: View {
    // FIXME: これ使いたくないよぉ。。
    @Binding var shouldScanningFace: Bool
    @State var isShowEyebrowMenu = false
    @ObservedObject var viewModel = EyebrowSupportViewModel()
    
    //FIXME: 初回起動かどうかを見極めて、初回起動なら顔スキャン画面を出す。
    
    // ARの画面、下にボタン
    var body: some View {
        ZStack {
            TestAR(viewModel: viewModel)
                .onAppear {
                    viewModel.setEyebrowPosition()
                }
            VStack {
                Spacer()
                MainMenuBar(shouldScanningFace: $shouldScanningFace, isShowEyebrowMenu: $isShowEyebrowMenu)
            }
            
            EyebrowMenuBar(isShowEyebrowMenu: $isShowEyebrowMenu, viewModel: viewModel)
        }
    }
}
//
//struct MakeupView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeupView()
//    }
//}
