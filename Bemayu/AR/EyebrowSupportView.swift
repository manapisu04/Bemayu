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
        
        node.addChildNode(makeImageNode(name: "cat"))
        node.addChildNode(makeImageNode(name: "mayuge2"))
        
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
                viewModel.oldImage = viewModel.newImage
                viewModel.tappedImage = false
            }
        
        }
        
        if let child = node.childNode(withName: viewModel.newImage, recursively: false) {
            print("ぽけけ")
            //FIXME: 眉毛の位置にする?
            child.position = viewModel.rigftEyebrowPosition ?? SCNVector3(0, 0, 0)
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
        let imageGeo = SCNPlane(width: 0.02, height: 0.01)
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
        if let oldNode = node.childNode(withName: viewModel.oldImage, recursively: false),
            let newNode = node.childNode(withName: viewModel.newImage, recursively: false) {
            print("あるある")
            oldNode.opacity = 0.0
            print("あったあった")
            newNode.opacity = 1.0
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
