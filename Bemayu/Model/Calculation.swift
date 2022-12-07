//
//  Calculation.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/09.
//

import Foundation
import ARKit

// 計算用
struct CalculationDistance {
//    let eyesDistance: Double
//    let eyesDistanceByVisionFramework: Double
    
//    init(leftEyePosition: Position, rightEyePosition: Position) {
//        // ARで取得した値をcmに直す
//        let leftPosition = leftEyePosition.arKit
//        let rightPosition = rightEyePosition.arKit
//        let position = SCNVector3Make(leftPosition.x - rightPosition.x, leftPosition.y - rightPosition.y, leftPosition.z - rightPosition.z)
//        let distance = sqrt(position.x * position.x + position.y * position.y + position.z * position.z)
//        self.eyesDistance = Double(distance * 100.0)
//
//        // Visionでとったものをcmに直す
////        self.eyesDistanceByVisionFramework = 0.0
//    }
    
    func distance(rangeOfSpotAndEyebrow: CGFloat) {
        // 左右の距離を一旦cmに直す
        

        // 目と目の距離をcmに直す
        // ARKitで目と目の距離のcmを取ってくる
        // ARKitで取った目の距離とVisionで取った目の距離で縮図的なアレをする（比例・比率）
        // 左右の距離のcmを上に比例させる
        // cmをSCNVector3にconvertする
    }
    
    /*
     CGFloatをSCNVector3に変換する
     */
    func convertingToSCNVector3(cgFloat: CGFloat, magnification: Double) -> SCNVector3 {
        let distanceByAR = cgFloat * magnification
        print(distanceByAR)
        
        // FIXME: 仮置き
        return SCNVector3(0, 0, 0)
    }
    
    /*
     CGFloatをセンチメートルに変換する
     */
    private func convertToCM(cgFloat: CGFloat) -> Double {
        let cm: Double = Double(cgFloat / 10.0)
        // FIXME: 仮置き
        return cm
    }
    
    // ピタゴラスの定理。。。omg
    func pythagoreanTheorem(startPoint: CGPoint, endPoint: CGPoint) -> Double {
        let heightPoint = startPoint.y > endPoint.y ? startPoint : endPoint
        let rowPoint = heightPoint == startPoint ? endPoint : startPoint
        
        // heightPointとrowPointを使って直角を作る。直角三角形になる。
        let rightAnglePoint = CGPoint(x: heightPoint.x, y: rowPoint.y)
        
        // ピタゴラスの定理 A^2 = B^2 + C^2
        let sideB = abs(heightPoint.y - rightAnglePoint.y)
        let sideC = abs(rowPoint.x - rightAnglePoint.x)
        
        // 斜辺
        let sideA = sqrt((sideB * sideB) + (sideC * sideC))
        
        return Double(sideA)
    }
    
    // ARでの距離をとる…
    func distanceMeasurement(startPosition: SCNVector3, endPosition: SCNVector3) -> Double {
        print("hogehoge")
        print(endPosition.z)
        print(startPosition.z)
        print("hogehoge")
        let position = SCNVector3Make(endPosition.x - startPosition.x, endPosition.y - startPosition.y, endPosition.z - startPosition.z)
        let distance = sqrt(position.x * position.x + position.y * position.y + position.z * position.z)
        print(sqrt(position.x * position.x))
        print(sqrt(position.y * position.y))
        print(sqrt(position.z * position.z))
        
        return Double(distance)
    }
}

struct Position {
    let arKit: SCNVector3
    let vision: CGFloat
}
