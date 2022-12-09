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
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(value) else {
            return
        }
        // 保存
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load(key: String) -> SCNVector3? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: key),
              let value = try? jsonDecoder.decode(SCNVector3.self, from: data) else {
            return nil
        }
        
        return value
    }
}
