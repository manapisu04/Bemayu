//
//  FaceScan.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/08.
//

import AVFoundation
import UIKit
import Vision

class LiveFeedViewController: UIView {
    let captureSession = AVCaptureSession()
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    let videoDataOutput = AVCaptureVideoDataOutput()
    var faceLayers: [CAShapeLayer] = []
    
    var viewModel: FaceScanViewModel?
    
    /*
     入力をインナーカメラに設定する
     */
    func setupCamera() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
    
        if let device = deviceDiscoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: device) {
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                    
                    setupPreview()
                }
            }
        }
    }
    
    /*
     プレビューの設定を行う
     */
    private func setupPreview() {
        
        self.previewLayer.videoGravity = .resizeAspectFill
        
        // FIXME: main.bouns使いたくないな
        self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size)
        
        // FIXME: 乗っからない
        let arView = FaceTracking(viewModel: self.viewModel!).ARView
        arView.frame = self.frame
        self.addSubview(arView)
        
        // プレビューの大きさをレイヤーと同じにする
        self.previewLayer.frame = self.frame
        self.layer.addSublayer(self.previewLayer)
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        let videoConnection = self.videoDataOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait

    }
    
    /*
     セッションのスタート
     */
    func run() {
        DispatchQueue(label: "Background", qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}

extension LiveFeedViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
          return
        }

        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                self.faceLayers.forEach({ drawing in drawing.removeFromSuperlayer() })

                if let observations = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionObservations(observations: observations)
                }
            }
        })

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .leftMirrored, options: [:])

        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
          print(error.localizedDescription)
        }
    }
    
    private func handleFaceDetectionObservations(observations: [VNFaceObservation]) {
        for observation in observations {
            let faceRectConverted = self.previewLayer.layerRectConverted(fromMetadataOutputRect: observation.boundingBox)
            let faceRectanglePath = CGPath(rect: faceRectConverted, transform: nil)
            
            let faceLayer = CAShapeLayer()
            faceLayer.path = faceRectanglePath
            faceLayer.fillColor = UIColor.clear.cgColor
            
            self.faceLayers.append(faceLayer)
            self.layer.addSublayer(faceLayer)
            
            
        
            if let landmarks = observation.landmarks {

                if let leftEyebrow = landmarks.leftEyebrow {
                    self.handleLandmark(leftEyebrow, faceBoundingBox: faceRectConverted, parts: .leftEyebrow)
                }

                if let rightEyebrow = landmarks.rightEyebrow {
                    self.handleLandmark(rightEyebrow, faceBoundingBox: faceRectConverted, parts: .rightEyebrow)
                }
                
                if let leftEye = landmarks.leftEye {
                    self.handleLandmark(leftEye, faceBoundingBox: faceRectConverted, parts: .leftEye)
                }
                
                if let rightEye = landmarks.rightEye {
                    self.handleLandmark(rightEye, faceBoundingBox: faceRectConverted, parts: .rightEye)
                }
                
                

            }
        }
    }
    
    
    /*
     ランドマークを取得し、プロパティに詰め込む。
     */
    private func handleLandmark(_ eye: VNFaceLandmarkRegion2D, faceBoundingBox: CGRect, parts: Parts) {
        let landmarkPath = CGMutablePath()
        let landmarkPathPoints = eye.normalizedPoints
            .map({ eyePoint in
                CGPoint(
                    x: eyePoint.y * faceBoundingBox.height + faceBoundingBox.origin.x,
                    y: eyePoint.x * faceBoundingBox.width + faceBoundingBox.origin.y
                )
            })
        
        guard let viewModel else { return }
        
        switch(parts) {
        case .leftEye:
            viewModel.leftEye = landmarkPathPoints
            
        case .rightEye:
            viewModel.rightEye = landmarkPathPoints
            
        case .leftEyebrow:
            viewModel.leftEyebrow = landmarkPathPoints
            
        case .rightEyebrow:
            viewModel.rightEyebrow = landmarkPathPoints
        }
        
        landmarkPath.addLines(between: landmarkPathPoints)
        landmarkPath.closeSubpath()
        let landmarkLayer = CAShapeLayer()
        landmarkLayer.path = landmarkPath
        landmarkLayer.fillColor = UIColor.clear.cgColor
        landmarkLayer.strokeColor = UIColor.green.cgColor

        self.faceLayers.append(landmarkLayer)
        self.layer.addSublayer(landmarkLayer)
        

    }
}

enum Parts {
    case leftEye
    case rightEye
    case leftEyebrow
    case rightEyebrow
}
