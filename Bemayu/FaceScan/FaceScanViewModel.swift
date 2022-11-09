//
//  FaceScanViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/08.
//

import Foundation
import Combine

class FaceScanViewModel: ObservableObject {
    // 目と眉の矩形を保存しておく。
    @Published var leftEye: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    @Published var rightEye: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    @Published var leftEyebrow: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    @Published var rightEyebrow: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]

    /// 左目と左眉の距離
    var leftDistance: CGFloat {
        get {
            return leftEye[3].y - leftEyebrow[3].y
        }
    }
    
    /// 右目と右眉の距離
    var rightDistance: Double {
        get {
            return rightEye[3].y - rightEyebrow[3].y
        }
    }
    
    //保存の処理
}
