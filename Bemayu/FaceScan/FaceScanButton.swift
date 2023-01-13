//
//  FaceScanButton.swift
//  Bemayu
//
//  Created by cmStudent on 2023/01/10.
//

import SwiftUI

struct FaceScanButton: View {
    var body: some View {
        if #available(iOS 16, *) {
            Image(systemName: "button.programmable")
                .renderingMode(.template)
        } else {
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 3.0)
                    .frame(width: 40.0)
                Circle()
                    .frame(width: 30.0)
            }
        }
    }
}

struct FaceScanButton_Previews: PreviewProvider {
    static var previews: some View {
        FaceScanButton()
    }
}
