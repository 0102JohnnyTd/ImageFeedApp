//
//  MosaicLayout.swift
//  ImageFeedApp
//
//  Created by Johnny Toda on 2023/01/15.
//

import UIKit

// ItemのLayoutパターンを列挙
private enum MosaicSegmentStyle {
    case fullWidth
    case fiftyFifty
    case twoThirdsOneThird
    case oneThirdTwoThirds
}

class MosaicLayout: UICollectionViewLayout {
    var contentBounds = CGRect.zero
    // レイアウトのキャッシュを保存しとく配列?
    var cachedAttributes: [UICollectionViewLayoutAttributes] = []

    // レイアウトが無効化される度に呼び出される
       // レイアウトの無効化 = ex) デバイスの向きが変わった時
    override func prepare() {
        super.prepare()

        guard let cv = collectionView else { return }
        // 古いキャッシュは初期化する
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: cv.bounds.size)

        // 各ItemのLayoutを設置
        createAttributes(cv: cv)
    }

    private func createAttributes(cv: UICollectionView) {
        // 0番目のインデックスに該当するSectionのItem数を取得
        let count = cv.numberOfItems(inSection: 0)
        // Itemのindexを管理する値
        var currentIndex = 0

        // 初期のレイアウトパターンをfullWidthに設定
        var segment: MosaicSegmentStyle = .fullWidth
        // 原点とサイズが共に0の矩形
        var lastFrame: CGRect = .zero

        // CollectionViewの幅を取得
        let cvWidth = cv.bounds.size.width

        // Item数が現在のインデックスより大きい場合スコープの中の処理を繰り返す
           // ちなみにサンプルのItem数は50,000(どこで決めてんやろ。)なので、50,000回程この中の処理が繰り返されることになる。
        while currentIndex < count {
            // 加工前の矩形を生成
            // y: lastFrame.maxY + 1.0 = Sectionの下辺に1.0のスペースを作る
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 1.0, width: cvWidth, height: 200.0)

            // 分割して加工した矩形を保管する為の配列
            var segmentRects: [CGRect] = []

            // 1周目はfullWidth
            switch segment {
            case .fullWidth:
                // 特にLayoutを変更する必要はないのでそのまま渡す
                segmentRects = [segmentFrame]
            case .fiftyFifty:
                // from .minXedgeなのでdimensionにはself.size.width(cvWidth)が入る
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge)
                // 2分割した矩形をsegmentSectsに渡す
                segmentRects = [horizontalSlices.first, horizontalSlices.second]
            case .twoThirdsOneThird:
                // from .minXedgeなのでdimensionにはself.size.width(cvWidth)が入る
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (2.0 / 3.0), from: .minXEdge)
                // second = 分割した矩形の外側の矩形をさらに縦軸で中央の位置に分割する
                let verticalSlices = horizontalSlices.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [horizontalSlices.first, verticalSlices.first, verticalSlices.second]

            case .oneThirdTwoThirds:
                // from .minXedgeなのでdimensionにはself.size.width(cvWidth)が入る
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (1.0 / 3.0), from: .minXEdge)
                // second = 分割した矩形の外側の矩形をさらに縦軸で中央の位置に分割する
                let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
            }

            // レイアウトのキャッシュを作成
            segmentRects.forEach { rect in
                // レイアウト属性のオブジェクトを作成
                // IndexPath(item: currentIndex, section: 0) ⇦ 0番目のSectionの(最初なら)0番目のItemを参照
                   // 常に0番目のSection指定だと一つのSectionにしか適応されないはずでは？実際そうはなってないんだけど。
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                // オブジェクトのframeにrect(分割した矩形)を渡す
                attributes.frame = rect
                // レイアウトのキャッシュを保存しておく配列にレイアウト属性オブジェクトを追加
                cachedAttributes.append(attributes)
                // 一つのSection内でひたすらコンテンツを繋ぎ合わせる
                contentBounds = contentBounds.union(lastFrame)

                // Itemのindexを+1する(これがないと処理が無限ループする)
                currentIndex += 1
                // lastFrameを更新する
                lastFrame = rect
            }

            // 次のSegmentスタイルを決定する
            // count = n番目のインデックスに該当するSectionのItem数を取得
               // 公式のItem数は50,000だった。大杉。
            // ex: 1周目) 50,000 - 1 = 49,999
            switch count - currentIndex {
            // 最後はここが呼ばれる
            case 1:
                segment = .fullWidth
            // 49998周目はここが呼ばれる
            case 2:
                segment = .fiftyFifty
            // 1-49997周目はここが呼ばれる
            default:
                // 順次Segmentが切り替わる
                switch segment {
                case .fullWidth:
                    segment = .fiftyFifty
                case .fiftyFifty:
                    segment = .twoThirdsOneThird
                case .twoThirdsOneThird:
                    segment = .oneThirdTwoThirds
                case .oneThirdTwoThirds:
                    segment = .fiftyFifty
                }
            }
        }
    }

    // CollectionViewのコンテンツサイズを設定
    override var collectionViewContentSize: CGSize { contentBounds.size }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false }
        return !newBounds.size.equalTo(cv.bounds.size)
    }

    // 要求したIndexPathに合う属性を配列から選出
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes[indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cachedAttributes.filter { (attributes: UICollectionViewLayoutAttributes) -> Bool in
            rect.intersects(attributes.frame)
        }
    }
}
