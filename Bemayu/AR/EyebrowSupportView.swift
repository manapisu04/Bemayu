//
//  EyebrowSupportView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

// ARを利用した眉ガイド表示View。
import SwiftUI
import ARKit

struct EyebrowSupportView: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    
    var arView: ARSCNView
    
    private var faceNode: SCNNode
    
    @ObservedObject var viewModel: EyebrowSupportViewModel
    
    init(viewModel: EyebrowSupportViewModel) {
        self.viewModel = viewModel
        self.arView = ARSCNView()
        self.faceNode = SCNNode()
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        setARView()
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        run()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func setARView() {
        
        arView.session = ARSession()
        arView.scene = SCNScene()
        
        if let geometry = faceNode.geometry {
            let node = SCNNode(geometry: geometry)
            geometry.firstMaterial?.diffuse.contents = UIColor.blue
            arView.scene.rootNode.addChildNode(node)
            
        }
    }
    
    private func run() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 1
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

final class Coordinator: NSObject, ARSCNViewDelegate {
    let parent: EyebrowSupportView
    
    var leftEyeNode = SCNReferenceNode()
    var rightEyeNode = SCNReferenceNode()
    
    init(_ sampleAR: EyebrowSupportView) {
        self.parent = sampleAR
    }
    
    // 新しく追加されたアンカーに対応する SceneKit ノードを提供するようにデリゲートに依頼
    // ここで形やARで何出すか？を作ってる。オブジェクトを生成してる。
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // ARSCNView、ARFaceAnchorを取得
        guard let sceneView = renderer as? ARSCNView, anchor is ARFaceAnchor else {
            return nil
        }
        
        // フェイスジオメトリを持つノードを新規生成
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: true)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        // 眉毛の画像を表示させたい
        let imageNode = SCNNode()
        //FIXME: 大きさ調整
        let imageGeo = SCNPlane(width: 0.02, height: 0.01)
        imageGeo.firstMaterial?.diffuse.contents = UIImage(named: parent.viewModel.image.rawValue)
        imageNode.geometry = imageGeo
        imageNode.name = "image"
        imageNode.position = SCNVector3(0, 0, 0)
        node.addChildNode(imageNode)
        imageNode.geometry?.firstMaterial?.fillMode = .fill
        
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    // ここは顔が認知されるとずっと更新される
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // ARFaceAnchor、ARSCNFaceGeometryを取得
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        print("==============================")
        let child = node.childNode(withName: "image", recursively: false)
        if let child {
            //FIXME: 眉毛の位置にする
            child.position = SCNVector3(faceAnchor.geometry.vertices[100])
            print(child.position.x)
            print(child.position.y)
            print(child.position.z)
        }
        
        
        
        // フェイスジオメトリを更新
        faceGeometry.update(from: faceAnchor.geometry)
    }
}


