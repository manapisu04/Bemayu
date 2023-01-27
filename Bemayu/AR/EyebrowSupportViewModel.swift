//
//  EyebrowSupportViewModel.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/25.
//

import SwiftUI
import ARKit

class EyebrowSupportViewModel: ObservableObject {
    // 初期値はダミー
    @Published var oldImages = (left: "chokusen_l_b", right: "chokusen_r_b")
    @Published var newImages = (left: "chokusen_l_r", right: "chokusen_r_r")
    @Published var tappedImage: Bool = false
    @Published var hasTapped: Bool = false
    
    var lineColor: LineColor = .red {
        willSet {
            let leftImage = eyebrowImage + "_l" + newValue.rawValue
            let rightImage = eyebrowImage + "_r" + newValue.rawValue
            self.newImages = (left: leftImage, right: rightImage)
        }
    }
    
    var leftEyebrowPosition: SCNVector3?
    var rigftEyebrowPosition: SCNVector3?
    
    let facePartsService = FacePartsService.shared
    
    var eyebrowImage = "chokusen" {
        willSet {
            let leftImage = newValue + "_l" + self.lineColor.rawValue
            let rightImage = newValue + "_r" + self.lineColor.rawValue
            self.newImages = (left: leftImage, right: rightImage)
        }
    }
    
    
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
    
    func tappedColorButton() {
        changeImage(left: self.newImages.left, right: self.newImages.right)
    }
    
    func changeImage(left: String, right: String) {
        //        let leftImageName = left + lineColor.rawValue
        //        let rightImageName = right + lineColor.rawValue
        self.newImages = (left: left, right: right)
        //TODO: 永続化の処理
    }
    
    func tappedImage(eyebrowImage: EyebrowImage) {
        self.eyebrowImage = eyebrowImage.image
        
    }
}


enum EyebrowImage: CaseIterable, Identifiable {
    var id: String { image }
    
    case chokusen
    case heikoumayu
    case arch
    case sharp
    
    var type: Impression {
        switch self {
        case .chokusen, .sharp:
            return .cool
        case .heikoumayu:
            return .cute
        case .arch:
            return .natural
        }
    }
    
    var tag: String {
        switch self {
        case .chokusen:
            return "きりっと"
        case .heikoumayu:
            return "かわいい"
        case .arch:
            return "ナチュラル"
        case .sharp:
            return "かっこいい"
        }
    }
    
    var buttonImage: String {
        switch self {
        case .chokusen, .sharp:
            return "cool1"
        case .heikoumayu:
            return "cute_h"
        case .arch:
            return "natural1"
        }
    }
    
    
    var image: String {
        switch self {
        case .chokusen:
            return "chokusen"
        case .heikoumayu:
            return "heikoumayu"
        case .arch:
            return "arch"
        case .sharp:
            return "sharp"
        }
    }
}

enum LineColor: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case black = "_b"
    case green = "_g"
    case red = "_r"
    
    func color() -> Color {
        switch self {
        case .black:
            return .black
        case .green:
            return .green
        case .red:
            return .red
        }
    }
}
