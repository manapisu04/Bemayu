//
//  MainMenuButton.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/21.
//

import SwiftUI

struct MainMenuButton: View {
    let systemName: String
    let label: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("barColor"))
                .frame(width: 100.0, height: 100.0)
                
            VStack {
                Image(systemName: systemName)
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .font(.system(size: 50.0))
                    .frame(width: 20.0, height: 40.0)
                Text(label)
                    .foregroundColor(.white)
            }
        }
    }
}
struct MainMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuButton(systemName: "faceid", label: "face")
    }
}
