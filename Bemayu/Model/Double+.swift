//
//  Double+.swift
//  Bemayu
//
//  Created by cmStudent on 2022/11/22.
//

import Foundation

extension Double {
    /*
     引数に対する倍率を求める
     */
    func multiplierFor(_ num: Double) -> Double {
        let magnification = self.magnitude / num
        return magnification
    }
}
