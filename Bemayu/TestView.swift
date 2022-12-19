//
//  TestView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/07.
//

import SwiftUI

struct TestView: View {
    var str = String(Int.random(in: 1...10))
    var body: some View {
        Text(str)
    }
}

struct TestEyebrowView: View {
    var body: some View {
        Text("Eyebrow...")
    }
}
