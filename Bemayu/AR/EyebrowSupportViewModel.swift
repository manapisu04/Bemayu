//
//  EyebrowSupportViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/25.
//

import SwiftUI
import ARKit

class EyebrowSupportViewModel: ObservableObject {
    //FIXME: ここも永続化できると良い
    @Published var oldImages = (left: "arch_l_b", right: "arch_r_b")
    @Published var newImages = (left: "arch_l_b", right: "arch_r_b")
    @Published var tappedImage: Bool = false
    @Published var lineColor: LineColor = .black
    
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
    
    func tappedButton(name: String) {
        // 処理
    }
    
    func changeImage(left: String, right: String) {
        let leftImageName = left + lineColor.rawValue
        let rightImageName = right + lineColor.rawValue
        self.newImages = (left: leftImageName, right: rightImageName)
        //TODO: 永続化の処理
    }
}

struct Eyebrow: Identifiable {
    let id = UUID()
    let tag: String
    let buttonImage: String
    let type: Impression
    let leftImage: String
    let rightImage: String
}

struct Images {
    static let shared: Images = .init()
    let eyebrows: [Eyebrow]
    
    private init() {
        var eyebrowsArray: [Eyebrow] = []
        eyebrowsArray.append(.init(tag: "きりっと", buttonImage: "cool1", type: .cool, leftImage: "chokusen_l", rightImage: "chokusen_r"))
        eyebrowsArray.append(.init(tag: "かわいい", buttonImage: "cute_h", type: .cute, leftImage: "heikoumayu_l", rightImage: "heikoumayu_r"))
        eyebrowsArray.append(.init(tag: "ナチュラル", buttonImage: "natural1", type: .natural, leftImage: "arch_l", rightImage: "arch_r"))
        eyebrowsArray.append(.init(tag: "かっこいい", buttonImage: "cool1", type: .cool, leftImage: "sharp_l", rightImage: "sharp_r"))
        
        self.eyebrows = eyebrowsArray
    }
}

enum LineColor: String {
    case black = "_b"
    case green = "_g"
    
    func color() -> Color {
        switch self {
        case .black:
            return .black
        case .green:
            return .green
        }
    }
}
