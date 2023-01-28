//
//  FriendsViewController.swift
//  ImageFeedApp
//
//  Created by Johnny Toda on 2023/01/08.
//

import UIKit

final class FriendsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var flowLayout: ColumnFlowLayout!
    private var people = sampleData()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        // CollectionView内のLayoutを設定するクラスをインスタンス化
        flowLayout = ColumnFlowLayout()

        // UICollectionViewクラスのインスタンスを生成
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .appBackgroundColor
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)

        // Cellを登録
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: PersonCell.identifier)

        // Cellのプロトコルの通知先をFriendsViewControllerに設定
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // サンプルデータ
    static func sampleData() -> [Person] {[
            Person(name: "Erika", day: 22, month: 10, year: 2022),
            Person(name: "Ramos", day: 11, month: 12, year: 2022),
            Person(name: "Zeyn", day: 26, month: 3, year: 2022),
            Person(name: "Ken", day: 19, month: 4, year: 2022)
        ]
    }
}

// MARK: Data source
extension FriendsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.identifier, for: indexPath) as! PersonCell
        cell.person = people[indexPath.item]
        return cell
    }
}

extension FriendsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // コードのみでViewを構築する際は画面のインスタンス生成時にLayoutも初期化しておかないとアプリがクラッシュする
        let feedVC = FeedViewController(collectionViewLayout: MosaicLayout())

        if let indexPaths = collectionView.indexPathsForSelectedItems {
            let indexPath = indexPaths[0]
            print("\(String(describing: indexPath))")
            let person = people[indexPath.row] as Person
            feedVC.person = person
            navigationController?.pushViewController(feedVC, animated: true)
        }
    }
}
