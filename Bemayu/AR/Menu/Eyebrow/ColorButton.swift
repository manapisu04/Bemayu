//
//  ColorButton.swift
//  Bemayu
//
//  Created by cmStudent on 2023/01/11.
//

import SwiftUI

struct ColorButton: View {
    @Binding var selectedColor: LineColor
    let circleColor: LineColor
    var body: some View {
        Button {
            selectedColor = circleColor
        } label: {
            ZStack {
                Circle()
                    .frame(width: 22.0)
                    .foregroundColor(selectedColor == circleColor ? circleColor.color() : Color.white)
                Circle()
                    .frame(width: 20.0)
                    .foregroundColor(circleColor.color())
            }
        }
    }
}

//struct ColorButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorButton(circleColor: .green)
//    }
//}
