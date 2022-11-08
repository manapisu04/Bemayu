//
//  ContentView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

struct ContentView: View {
    @State var shouldScanningFace = false
    
    //FIXME: 初回起動かどうかを見極めて、初回起動なら顔スキャン画面を出す。
    
    var body: some View {
        if shouldScanningFace {
            FaceScanView(shouldScanningFace: $shouldScanningFace)
        } else {
            MakeupView(shouldScanningFace: $shouldScanningFace)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
