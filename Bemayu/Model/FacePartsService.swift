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
class FacePartsService {
    static let shared: FacePartsService = .init()
    
    private init() {}
    
    func save(value: SCNVector3, key: String) {
        
        // 保存
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func load(key: String) -> SCNVector3? {
        var value = UserDefaults.standard.object(forKey: key)
        guard let value = value as? SCNVector3 else {
            return nil
        }
        
        return value
    }
}
