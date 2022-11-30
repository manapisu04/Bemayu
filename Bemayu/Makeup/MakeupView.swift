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
    
    @State var test = false
    //FIXME: 初回起動かどうかを見極めて、初回起動なら顔スキャン画面を出す。
    
    // ARの画面、下にボタン
    var body: some View {
        ZStack {
            if test {
//                TestView()
                EyebrowSupportView(viewModel: viewModel)
            } else {
                EyebrowSupportView(viewModel: viewModel)
            }
            VStack {
                Spacer()
                MainMenuBar(shouldScanningFace: $shouldScanningFace, isShowEyebrowMenu: $isShowEyebrowMenu, test: $test)
            }
            
            EyebrowMenuBar(isShowEyebrowMenu: $isShowEyebrowMenu, viewModel: viewModel, test: $test)
        }
    }
}
//
//struct MakeupView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeupView()
//    }
//}
