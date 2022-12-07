//
//  DescriptionView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/08.
//

import SwiftUI

// FIXME: あとで上下からにゅ〜ってでてくるようなアニメーションをつける
struct DescriptionView: View {
    @Binding var shouldScanningFace: Bool
    @ObservedObject var viewModel: FaceScanViewModel
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("barColor"))
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            self.shouldScanningFace = false
                        } label: {
                            Text("キャンセル")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                    .padding(20.0)
                    Text("フレームにお顔がおさまるように\n写真を撮ってください。")
                        .foregroundColor(.white)
                }
            }
            .frame(width: .infinity, height: 150.0)
            Spacer()
            ZStack {
                Rectangle()
                    .foregroundColor(Color("barColor"))
                Button {
                    // TODO: shouldをfalseにして、眉と目の距離を端末に保存する処理
                    viewModel.tappedButton()
                } label: {
                    Image(systemName: "button.programmable")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .font(.system(size: 70.0))
                }
            }
            .frame(width: .infinity, height: 120.0)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct DescriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        DescriptionView()
//    }
//}
