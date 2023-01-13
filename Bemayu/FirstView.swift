//
//  FirstView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/12/16.
//

import SwiftUI

struct FirstView: View {
    @State var shouldScanningFace = false
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100.0)
                    .padding()
                Spacer()
                    .frame(height: 25.0)
                Button {
                    shouldScanningFace = true
                } label: {
                    Text("使ってみる")
                        .bold()
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color("barColor"))
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $shouldScanningFace) {
                    FaceScanView(shouldScanningFace: $shouldScanningFace)
                }
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
