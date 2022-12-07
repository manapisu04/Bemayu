//
//  EyebrowSupportViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/25.
//

import Foundation

class EyebrowSupportViewModel: ObservableObject {
    //FIXME: ここも永続化できると良い
    @Published var oldImage = "mayuge2"
    @Published var newImage = "mayuge2"
    @Published var tappedImage: Bool = false
    
    func load(key: String) {
        
    }
    
    func changeImage(name: String) {
        self.newImage = name
        //TODO: 永続化の処理
    }
}
