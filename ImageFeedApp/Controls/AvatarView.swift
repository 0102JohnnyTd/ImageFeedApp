//
//  AvatarView.swift
//  ImageFeedApp
//
//  Created by Johnny Toda on 2023/01/12.
//

import UIKit

// FeedViewControllerのNavigationBar上に表示するPersonのプロフィール画像のクラス
class AvatarView: UIView {
    let avatarImgView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 36, height: 44))

        let avatar = #imageLiteral(resourceName: "zeyn")
        avatarImgView.image = avatar
        avatarImgView.contentMode = .scaleAspectFill
        avatarImgView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.addSubview(avatarImgView)

        avatarImgView.layer.borderWidth = 1.0
        avatarImgView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        avatarImgView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let newHeight = self.frame.size.height - 8.0
        avatarImgView.bounds = CGRect(x: 0, y: 0, width: newHeight, height: newHeight)
        avatarImgView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        avatarImgView.layer.cornerRadius = newHeight / 2.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
