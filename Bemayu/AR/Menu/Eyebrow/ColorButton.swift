//
//  ColorButton.swift
//  Bemayu
//
//  Created by cmStudent on 2023/01/11.
//

import SwiftUI

struct ColorButton: View {
    @StateObject var viewModel: EyebrowSupportViewModel
    @Binding var selectedColor: LineColor
    let circleColor: LineColor
    var body: some View {
        
        Button {
            selectedColor = circleColor
            viewModel.tappedColorButton()
            viewModel.tappedImage = true
        } label: {
            ZStack {
                Circle()
                    .frame(width: 22.0)
                    .foregroundColor(Color.white)
                Circle()
                    .frame(width: 20.0)
                    .foregroundColor(circleColor.color())
            }
        }
    }
}

struct ColorButtons: View {
    @StateObject var viewModel: EyebrowSupportViewModel
    @Binding var selectedColor: LineColor
    var body: some View {
        HStack {
            ForEach(LineColor.allCases) { color in
                ColorButton(viewModel: viewModel, selectedColor: $selectedColor, circleColor: color)
            }
        }
    }
}

