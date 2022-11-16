//
//  FaceScanCameraView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/08.
//

import SwiftUI

struct FaceScanCameraView: UIViewRepresentable {
    typealias UIViewType = LiveFeedViewController
    @ObservedObject var viewModel: FaceScanViewModel

    func makeUIView(context: Context) -> LiveFeedViewController {
        let view = LiveFeedViewController()
        view.viewModel = viewModel
//        view.setupCamera()
        view.run()
        return view
    }
    
    func updateUIView(_ uiView: LiveFeedViewController, context: Context) {
        
    }
    
}
