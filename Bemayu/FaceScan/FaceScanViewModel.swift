//
//  FaceScanViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/08.
//

import Foundation
import ARKit

class FaceScanViewModel: ObservableObject {
    let facePartsService = FacePartsService.shared
    // 目と眉の矩形を保存しておく。長さももしかしたら使うかも？なので、
    var leftEyePoints: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var rightEyePoints: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var leftEyebrowPoints: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var rightEyebrowPoints: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    
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
            return leftEyePoints[3].y - leftEyebrowPoints[3].y
        }
    }
    
    /// 右目と右眉の距離
    var rightDistance: CGFloat {
        get {
            return rightEyePoints[3].y - rightEyebrowPoints[3].y
        }
    }
    
    
    //保存の処理
    func saveDistance(value: SCNVector3, key: String) {
        facePartsService.save(value: value, key: key)
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
        
        let leftDistance = calcu.pythagoreanTheorem(startPoint: leftEyePoints[3], endPoint: leftEyebrowPoints[3])
        let rightDistance = calcu.pythagoreanTheorem(startPoint: rightEyePoints[3], endPoint: rightEyebrowPoints[3])
        
        // Visionでの両目の距離
        let eyesDistanceByVision = calcu.pythagoreanTheorem(startPoint: leftEyePoints[3], endPoint: rightEyePoints[3])
        
        // 倍率
        let magnification = eyesDistanceByAR.multiplierFor(eyesDistanceByVision)
        
        print("ぴけらった！")
        let leftEyebrowPosition = calcu.convertingToSCNVector3(cgFloat: leftDistance, magnification: magnification, scnVector3: leftEyePosition)
        
        let rightEyebrowPosition = calcu.convertingToSCNVector3(cgFloat: rightDistance, magnification: magnification, scnVector3: rightEyePosition)
        
        saveDistance(value: leftEyebrowPosition, key: leftEyebrow)
        saveDistance(value: rightEyebrowPosition, key: rightEyebrow)
        
        print(leftEyebrowPosition)
        // trueになるので、アラート表示などの処理を
        showAlert = true
    }
    
}
