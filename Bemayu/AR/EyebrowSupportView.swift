//
//  EyebrowSupportView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

// ARを利用した眉ガイド表示View。
import SwiftUI
import ARKit

// FIXME: あまりにおファット
class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView = ARSCNView()
    var faceNode = SCNNode()
    var viewModel: EyebrowSupportViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        setARView()
        self.view = sceneView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 1
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func setARView() {
        sceneView.session = ARSession()
        sceneView.scene = SCNScene()
        
        if let geometry = faceNode.geometry {
            let node = SCNNode(geometry: geometry)
            geometry.firstMaterial?.diffuse.contents = UIColor.blue
            sceneView.scene.rootNode.addChildNode(node)
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // ARSCNView、ARFaceAnchorを取得
        guard let sceneView = renderer as? ARSCNView, anchor is ARFaceAnchor else {
            return nil
        }
        
        // フェイスジオメトリを持つノードを新規生成
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: true)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        // ここで画像を登録してる
        for image in EyebrowImage.allCases {
            // 黒
            node.addChildNode(makeImageNode(name: image.image + "_l_b"))
            node.addChildNode(makeImageNode(name: image.image + "_r_b"))
            // 緑
            node.addChildNode(makeImageNode(name: image.image + "_l_g"))
            node.addChildNode(makeImageNode(name: image.image + "_r_g"))
            // 赤
            node.addChildNode(makeImageNode(name: image.image + "_l_r"))
            node.addChildNode(makeImageNode(name: image.image + "_r_r"))
        }
        
        print(node.childNodes.count)
        
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    // ここは顔が認知されるとずっと更新される
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // ARFaceAnchor、ARSCNFaceGeometryを取得
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        guard let viewModel else {
            faceGeometry.update(from: faceAnchor.geometry)
            return
        }
        
        if viewModel.tappedImage {
            print("ぴけらった！")
            selectedImage(node: node)
            
            DispatchQueue.main.async {
                viewModel.oldImages = viewModel.newImages
                viewModel.tappedImage = false
            }
        
        }
        
        if let leftEyebrowChild = node.childNode(withName: viewModel.newImages.left, recursively: false),
           let rightEyebrowChild = node.childNode(withName: viewModel.newImages.right, recursively: false) {
//            print("ぽけけ")
            // 眉毛の位置にする
            leftEyebrowChild.position = viewModel.leftEyebrowPosition ?? SCNVector3(0, 0, 0)
            rightEyebrowChild.position = viewModel.rigftEyebrowPosition ?? SCNVector3(0, 0, 0)
        }
        
        // フェイスジオメトリを更新
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    // OK
    private func makeImageNode(name: String) -> SCNNode {
        print("ほげほげ〜")
        // 眉毛の画像を表示させたい
        let imageNode = SCNNode()
        //FIXME: 大きさ調整
        let imageGeo = SCNPlane(width: 0.043, height: 0.01)
        imageGeo.firstMaterial?.diffuse.contents = UIImage(named: name)
        imageNode.geometry = imageGeo
        imageNode.name = name
        imageNode.position = SCNVector3(0, 0, 0)
        imageNode.opacity = 0.0
        imageNode.geometry?.firstMaterial?.fillMode = .fill
        
        return imageNode
    }
    
    func selectedImage(node: SCNNode) {
        guard let viewModel else { return }
        print("=========================")
        print(viewModel.oldImages.left)
        print(viewModel.newImages.left)
        print("=========================")
        
        if let oldLeftEyebrowNode = node.childNode(withName: viewModel.oldImages.left, recursively: false),
           let oldRightEyebrowNode = node.childNode(withName: viewModel.oldImages.right, recursively: false),
           let newLeftEyebrowNode = node.childNode(withName: viewModel.newImages.left, recursively: false),
           let newRightEyebrowNode = node.childNode(withName: viewModel.newImages.right, recursively: false) {
            // 前のノードを非表示に
            oldLeftEyebrowNode.opacity = 0.0
            oldRightEyebrowNode.opacity = 0.0
            
            // 新しいノードを表示する
            newLeftEyebrowNode.opacity = 0.8
            newRightEyebrowNode.opacity = 0.8
        }
        
    }
    
}


struct TestAR: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARViewController
    
    @ObservedObject var viewModel: EyebrowSupportViewModel
    
    func makeUIViewController(context: Context) -> ARViewController {
        let view = ARViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        uiViewController.viewModel = viewModel
    }
    
}
