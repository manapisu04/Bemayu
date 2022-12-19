//
//  SCNVector3+.swift
//  Bemayu
//
//  Created by cmStudent on 2022/12/09.
//

import ARKit

extension SCNVector3: Codable {
    enum CodingKeys: String, CodingKey {
            case x
            case y
            case z
        }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
        try container.encode(self.z, forKey: .z)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(Float.self, forKey: .x)
        let y = try container.decode(Float.self, forKey: .y)
        let z = try container.decode(Float.self, forKey: .z)
        
        self.init(x, y, z)
    }
    
    
}
