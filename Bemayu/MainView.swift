//
//  MainView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/12/16.
//

import SwiftUI

struct MainView: View {
    @State var shouldScanningFace = false
    
    var body: some View {
        if shouldScanningFace {
            FaceScanView(shouldScanningFace: $shouldScanningFace)
                .edgesIgnoringSafeArea(.all)
        } else {
            MakeupView(shouldScanningFace: $shouldScanningFace)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
