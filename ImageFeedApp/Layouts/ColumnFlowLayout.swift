//
//  ColumnFlowLayout.swift
//  ImageFeedApp
//
//  Created by Johnny Toda on 2023/01/08.
//

import UIKit

// FriendViewControllerに表示させるItemのレイアウトを構築するクラス
final class ColumnFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        // アンラップ
        guard let cv = collectionView else { return }

        // 🍏左右両端+8した上での残りの幅の値を返す値？
        self.itemSize = CGSize(width: cv.bounds.inset(by: cv.layoutMargins).size.width, height: 70.0)

        // Section間の間隔を設定
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: .zero, bottom: .zero, right: .zero)

        // 記述することでデバイスを横向きにした際にTrailing,LeadingにAutoLayoutを対応させる。
        self.sectionInsetReference = .fromSafeArea
    }
}

