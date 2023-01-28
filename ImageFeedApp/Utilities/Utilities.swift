//
//  Utilities.swift
//  ImageFeedApp
//
//  Created by Johnny Toda on 2023/01/10.
//

import UIKit

extension CGRect {
    // Viewを分割して、加工したそれぞれのViewを返す処理
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat

        // self.size.width = segmentFrame
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }

        // ex) fiftyFifty: dimension = about377, fraction = 0.5
           // 377 * 0.5 = 188.5 繰り上げで189
        let distance = (dimension * fraction).rounded(.up)

        // ex) fiftyFifty: fromEdge = minXEdge.そこから+189の位置で矩形を分割
        // 戻り値
           // reminder = 矩形を分割した線の内に含まれない残りの領域の矩形。
           // slice = 矩形を分割した線の内の部分
        var slices = self.divided(atDistance: distance, from: fromEdge)


        // ex) fiftyFifty: fromEdge = minXEdge
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            // 矩形を分割した線の外の矩形のX軸を原点から+1の位置にする。
            slices.remainder.origin.x += 1
            // 上記の処理で位置を+した分、CollectionViewの枠に収まるよう幅を-しておく。
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }

        // それぞれの矩形を返す
        return (first: slices.slice, second: slices.remainder)
    }
}

extension UIColor {
    static let appBackgroundColor = #colorLiteral(red: 0.05882352941, green: 0.09019607843, blue: 0.1098039216, alpha: 1)
}
