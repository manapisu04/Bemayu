//
//  EyebrowSupportViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/25.
//

import Foundation

class EyebrowSupportViewModel: ObservableObject {
    //FIXME: ここも永続化できると良い
    @Published var image: EyebrowsType = .test
    
    func load(key: String) {
        
    }
    
    func changeImage(name: EyebrowsType) {
        self.image = name
        //TODO: 永続化の処理
    }
}

/// 眉毛のイメージ
enum EyebrowsType: String {
    case test = "mayuge"
    case test2 = "mayuge2"
}

struct EyebrowImages {
    let left: String
    let right: String
}
