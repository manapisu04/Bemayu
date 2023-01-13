//
//  BemayuApp.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

@main
struct BemayuApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
        }
    }
}
