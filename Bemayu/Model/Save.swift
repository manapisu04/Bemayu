//
//  Save.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import Foundation
import ARKit
// 端末に記録する
// FIXME: Saveするだけにしたい。計算は他所でやってよ。
class Save {
    static let shared: Save = .init()
    
    private init() {}
    
    func saveDistance() {
        
        // 保存
    }
    
    /*
     一旦
     */
    func testMemo() {
        let endPosition = SCNVector3(0.018667722
                                     ,0.021741688
                                     ,0.038908463)
        let startPosition = SCNVector3(-0.017761663
                                        ,0.02152713
                                        ,0.03926072)
        let position = SCNVector3Make(endPosition.x - startPosition.x, endPosition.y - startPosition.y, endPosition.z - startPosition.z)
        let distance = sqrt(position.x * position.x + position.y * position.y + position.z * position.z)
        print(Double(distance * 100.0))
    }
}
