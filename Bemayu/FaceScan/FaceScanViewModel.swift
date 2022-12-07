//
//  FaceScanViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/08.
//

import Foundation
import ARKit

class FaceScanViewModel: ObservableObject {
    let save = FacePartsService.shared
    // 目と眉の矩形を保存しておく。長さももしかしたら使うかも？なので、
    var leftEye: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var rightEye: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var leftEyebrow: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var rightEyebrow: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    
    var leftEyePosition: SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    var rightEyePosition: SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    
    // フラグ
    var canFacialRecognize = false
    @Published var showAlert = false
    
    init() {
        
    }
    
    /// 左目と左眉の距離
    var leftDistance: CGFloat {
        get {
            return leftEye[3].y - leftEyebrow[3].y
        }
    }
    
    /// 右目と右眉の距離
    var rightDistance: CGFloat {
        get {
            return rightEye[3].y - rightEyebrow[3].y
        }
    }
    
    
    //保存の処理
    func saveDistance() {
        // うまく保存できなかったら処理とか
    }
    
    /*
     顔認識できている場合のみ、眉位置を保存する。
     */
    func tappedButton() {
        if !canFacialRecognize {
            showAlert = false
            return
        }
        
        let calcu = CalculationDistance()
        
        // ARでの両目の距離
        let eyesDistanceByAR = calcu.distanceMeasurement(startPosition: leftEyePosition, endPosition: rightEyePosition)
        
        let leftDistance = calcu.pythagoreanTheorem(startPoint: leftEye[3], endPoint: leftEyebrow[3])
        let rightDistance = calcu.pythagoreanTheorem(startPoint: rightEye[3], endPoint: rightEyebrow[3])
        
        // Visionでの両目の距離
        let eyesDistanceByVision = calcu.pythagoreanTheorem(startPoint: leftEye[3], endPoint: rightEye[3])
        
        let magnification = eyesDistanceByAR.multiplierFor(eyesDistanceByVision)
        
        print(calcu.convertingToSCNVector3(cgFloat: leftDistance, magnification: magnification))
        print(calcu.convertingToSCNVector3(cgFloat: rightDistance, magnification: magnification))
        
        // trueになるので、アラート表示などの処理を
        showAlert = true
    }
    
}
