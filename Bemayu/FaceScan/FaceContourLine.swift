//
//  FaceContourLine.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

// 輪郭ガイドの楕円形を作る。
struct FaceContourLine: View {
    // iPadとPhone以外対応しない。絶対にある！
    var widthRatio: CGFloat!
    var heightRatio: CGFloat!
    
    init() {
        // デバイスが何かを取得…
        let device = UIDevice.current.userInterfaceIdiom
        
        // iPadの場合の比率
        if device == .pad {
            self.widthRatio = 2.6
            self.heightRatio = 1.7
            
        // iPhoneの場合の比率
        } else if device == .phone {
            self.widthRatio = 1.2
            self.heightRatio = 2.0
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            
            VStack {
                Ellipse()
                    .stroke(lineWidth: 3)
                    .foregroundColor(.white)
                    .frame(width: geo.size.width / widthRatio, height: geo.size.height / heightRatio)
            }
            // 中心
            .frame(width: geo.size.width)
            .frame(height: geo.size.height)
        }
    }
}

struct FaceContourLine_Previews: PreviewProvider {
    static var previews: some View {
        FaceContourLine()
    }
}
