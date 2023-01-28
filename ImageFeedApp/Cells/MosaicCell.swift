//
//  MosaicCell.swift
//  ImageFeedApp
//
//  Created by Johnny Toda on 2023/01/26.
//

import UIKit

class MosaicCell: UICollectionViewCell {
    static let nib = UINib(nibName: String(describing: MosaicCell.self), bundle: nil)
    static let identifer = String(describing: MosaicCell.self)

    var imageView = UIImageView()
    var assetIdentifier: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.autoresizesSubviews = true

        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageView)

        // Use a random background color.
        let redColor = CGFloat(arc4random_uniform(255)) / 255.0
        let greenColor = CGFloat(arc4random_uniform(255)) / 255.0
        let blueColor = CGFloat(arc4random_uniform(255)) / 255.0
        self.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        assetIdentifier = nil
    }
}
