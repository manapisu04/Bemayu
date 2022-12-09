//
//  FaceScanAR.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/15.
//

import SwiftUI
import ARKit

struct FaceTracking: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    
    var ARView = ARSCNView()
    
    var faceNode = SCNNode()
    
    @ObservedObject var viewModel: FaceScanViewModel
    
    func makeUIView(context: Context) -> ARSCNView {
        ARView.delegate = context.coordinator
        setARView()
        return ARView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        run()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func setARView() {
        
        ARView.session = ARSession()
        ARView.scene = SCNScene()
        
        if let geometry = faceNode.geometry {
            let node = SCNNode(geometry: geometry)
            geometry.firstMaterial?.diffuse.contents = UIColor.blue
            ARView.scene.rootNode.addChildNode(node)
            
        }
    }
    
    private func run() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 1
        
        ARView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

final class Coordinator: NSObject, ARSCNViewDelegate {
    let parent: FaceTracking
    
    var leftEyeNode = SCNReferenceNode()
    var rightEyeNode = SCNReferenceNode()
    
    init(_ faceTrackingAR: FaceTracking) {
        self.parent = faceTrackingAR
    }
    
    // Asks the delegate to provide a SceneKit node corresponding to a newly added anchor.
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
    
    // ここは顔が認知されるとずっと更新される
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
                

                if let observations = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionObservations(observations: observations)
                    self.parent.viewModel.canFacialRecognize = true
                } else {
                    self.parent.viewModel.canFacialRecognize = false
                }
            
        })
        
        guard let frame =  self.parent.ARView.session.currentFrame else {
            // TODO: 現在握り潰し。何か処理があれば。
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
                
                // 358が左目、1168が右目
                if x == 358 {
                    self.parent.viewModel.leftEyePosition = child.position
                } else if x == 1168 {
                    self.parent.viewModel.rightEyePosition = child.position
                }
            }
            
            
        }
        
        // フェイスジオメトリを更新
        // ※更新することで、顔の表情を反映させる
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    // 表示する
    private func handleFaceDetectionObservations(observations: [VNFaceObservation]) {
        for observation in observations {
            
            if let landmarks = observation.landmarks {

                if let leftEyebrow = landmarks.leftEyebrow {
                    parent.viewModel.leftEyebrowPoints = leftEyebrow.normalizedPoints
                    print("まゆまゆ")
                }

                if let rightEyebrow = landmarks.rightEyebrow {
                    parent.viewModel.rightEyebrowPoints = rightEyebrow.normalizedPoints
                }
                
                if let leftEye = landmarks.leftEye {
                    parent.viewModel.leftEyePoints = leftEye.normalizedPoints
                }
                
                if let rightEye = landmarks.rightEye {
                    parent.viewModel.rightEyePoints = rightEye.normalizedPoints
                }
            }
        }
    }
    
}

