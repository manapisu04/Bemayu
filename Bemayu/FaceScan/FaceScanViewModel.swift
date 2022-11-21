//
//  FaceScanViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/08.
//

import Foundation
import ARKit

class FaceScanViewModel: ObservableObject {
    let save = Save.shared
    // 目と眉の矩形を保存しておく。長さももしかしたら使うかも？なので、
    var leftEye: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var rightEye: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var leftEyebrow: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    var rightEyebrow: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)]
    
    var leftEyePosition: SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    var rightEyePosition: SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    
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
    
    // 押すと目の距離がゲットできるぜよ！
    // FIXME: どっちも取れていなかった場合、この関数を押せなくする。
    func tappedButton() {
        let calcu = CalculationDistance()
        print("hogehoge")
        print(leftEye[3].x)
        print(leftEye[3].y)
        print("fugafuga")
        print(rightEye[3].x)
        print(rightEye[3].y)
        print("目の距離ぃ")
        print(calcu.pythagoreanTheorem(leftPoint: leftEye[3], rightPoint: rightEye[3]))
        print("目と眉の距離右")
        print(calcu.pythagoreanTheorem(leftPoint: leftEye[3], rightPoint: leftEyebrow[3]))
        print("ヒダリ")
        print(print(calcu.pythagoreanTheorem(leftPoint: rightEye[3], rightPoint: rightEyebrow[3])))
        print("AR")
        let cm = distanceMeasurement(startPosition: leftEyePosition, endPosition: rightEyePosition)
        print(cm)
    }
    
    // ARでの距離を、cmに変える…
    func distanceMeasurement(startPosition: SCNVector3, endPosition: SCNVector3) -> Double {
        print("hogehoge")
        print(endPosition.z)
        print(startPosition.z)
        print("hogehoge")
        let position = SCNVector3Make(endPosition.x - startPosition.x, endPosition.y - startPosition.y, endPosition.z - startPosition.z)
        let distance = sqrt(position.x * position.x + position.y * position.y + position.z * position.z)
        return Double(distance * 100.0)
    }
    
}
