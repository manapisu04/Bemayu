//
//  FaceScanView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI
// Visionを使用して、眉と目の距離を取得するための画面。
// 眉と目の距離を取得したら、端末に保存する。
// 遷移前に画面サイズを取得しておくと楽かもな〜！

struct FaceScanView: View {
    @Binding var shouldScanningFace: Bool
    @StateObject var viewModel = FaceScanViewModel()
    var body: some View {
        ZStack {
            TestScan(viewModel: viewModel)
            DescriptionView(shouldScanningFace: $shouldScanningFace, viewModel: viewModel)
            FaceContourLine()
        }
        .alert(Text("計測が完了しました！"), isPresented: $viewModel.showAlert) {
            Button {
                // FIXME: 初回起動ならオフにする
                if LaunchUtil.launchedVersion == "" {
                    LaunchUtil.launchedVersion = "Initial setup complete"
                    ContentViewModel.shared.switchStatus()
                }
                withAnimation(.linear) {
                    shouldScanningFace = false
                }
            } label: {
                Text("OK")
            }
        }
    }
}

//struct FaceScanView_Previews: PreviewProvider {
//    static var previews: some View {
//        FaceScanView()
//    }
//}
