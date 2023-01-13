//
//  FaceScanAR.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/15.
//

import SwiftUI
import ARKit

// FIXME: あまりにおファット
class ARFaceScanViewController: UIViewController, ARSCNViewDelegate {
    var sceneView = ARSCNView()
    var faceNode = SCNNode()
    var viewModel: FaceScanViewModel?
    
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
    
    // ここは顔が認知されるとずっと更新される
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { [self] (request: VNRequest, error: Error?) in
                
            guard let viewModel else { return }
                if let observations = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionObservations(observations: observations)
                    viewModel.canFacialRecognize = true
                } else {
                    viewModel.canFacialRecognize = false
                }
            
        })
        
        guard let frame =  self.sceneView.session.currentFrame else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: .leftMirrored, options: [:])

        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
          print(error.localizedDescription)
        }
        
        // ARFaceAnchor、ARSCNFaceGeometryを取得
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        for x in 0..<1220 {
            // 上で決めたネーム
            let child = node.childNode(withName: "\(x)", recursively: false)
            if let child {
                child.position = SCNVector3(faceAnchor.geometry.vertices[x])
                
                guard let viewModel else { return }
                // 358（いんなー）、1102（あうたー）が左目
                // 1168（いんなー）、1070（あうたー）が右目
                if x == 358 {
                    viewModel.leftEyeInnerPosition = child.position
                } else if x == 1168 {
                    viewModel.rightEyeInnerPosition = child.position
                } else if x == 1102 {
                    viewModel.leftEyeOuterPosition = child.position
                } else if x == 1070 {
                    viewModel.rightEyeOuterPosition = child.position
                }
            }
            
            
        }
        
        // フェイスジオメトリを更新
        // ※更新することで、顔の表情を反映させる
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    // 表示する
    private func handleFaceDetectionObservations(observations: [VNFaceObservation]) {
        guard let viewModel else { return }
        for observation in observations {
            
            if let landmarks = observation.landmarks {

                if let leftEyebrow = landmarks.leftEyebrow {
                    viewModel.leftEyebrowPoints = leftEyebrow.normalizedPoints
                    print("まゆまゆ")
                }

                if let rightEyebrow = landmarks.rightEyebrow {
                    viewModel.rightEyebrowPoints = rightEyebrow.normalizedPoints
                }
                
                if let leftEye = landmarks.leftEye {
                    viewModel.leftEyePoints = leftEye.normalizedPoints
                }
                
                if let rightEye = landmarks.rightEye {
                    viewModel.rightEyePoints = rightEye.normalizedPoints
                }
            }
        }
    }
    
    // 新しく追加されたアンカーに対応する SceneKit ノードを提供するようにデリゲートに依頼します、、という意味らしい
    // 一回しか通らない。顔面検知したら動く！すごい
    // ここで形やARで何出すか？を作ってる。オブジェクトを生成してる。
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // ARSCNView、ARFaceAnchorを取得
        guard let sceneView = renderer as? ARSCNView, anchor is ARFaceAnchor else {
            // TODO: 現在握り潰し
            return nil
        }
        
        // フェイスジオメトリを持つノードを新規生成。
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: true)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        for x in [1076, 1070, 1163, 1168, 1094, 358, 1108, 1102, 20, 661, 888, 822, 1047, 462, 376, 39, 1013] {
            let sphere = SCNSphere(radius: 0.001)
            let sphereNode = SCNNode(geometry: sphere)
            sphere.firstMaterial?.diffuse.contents = UIColor.white
            sphereNode.name = "\(x)"
            node.addChildNode(sphereNode)
            sphereNode.geometry?.firstMaterial?.fillMode = .fill
        }
        
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
}


struct ARFaceScan: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARFaceScanViewController
    
    @ObservedObject var viewModel: FaceScanViewModel
    
    func makeUIViewController(context: Context) -> ARFaceScanViewController {
        let view = ARFaceScanViewController()
        view.viewModel = viewModel
        return view
    }
    
    func updateUIViewController(_ uiViewController: ARFaceScanViewController, context: Context) {
        uiViewController.viewModel = viewModel
    }
    
}
