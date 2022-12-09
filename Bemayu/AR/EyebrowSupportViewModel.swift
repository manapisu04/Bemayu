//
//  EyebrowSupportViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/25.
//

import Foundation
import ARKit

class EyebrowSupportViewModel: ObservableObject {
    //FIXME: ここも永続化できると良い
    @Published var oldImage = "mayuge2"
    @Published var newImage = "mayuge2"
    @Published var tappedImage: Bool = false
    
    var leftEyebrowPosition: SCNVector3?
    var rigftEyebrowPosition: SCNVector3?
    
    let facePartsService = FacePartsService.shared
    
    func setEyebrowPosition() {
        if let leftEyebrowData = load(key: leftEyebrow),
           let rightEyebrowData = load(key: rightEyebrow) {
            leftEyebrowPosition = leftEyebrowData
            rigftEyebrowPosition = rightEyebrowData
        }
    }
    
    func load(key: String) -> SCNVector3? {
        if let position = facePartsService.load(key: key) {
            return position
        } else {
            return nil
        }
    }
    
    func changeImage(name: String) {
        self.newImage = name
        //TODO: 永続化の処理
    }
}
