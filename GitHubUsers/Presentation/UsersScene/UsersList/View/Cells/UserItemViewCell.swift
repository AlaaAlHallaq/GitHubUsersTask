//
//  UserItemViewCell.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import UIKit
import Kingfisher

class UserItemViewCell: UITableViewCell {
    static let height: CGFloat = 100
    static let reuseIdentifier = "UserItemViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    let userNameLabel = UILabel()
    let avatarImage = UIImageView()
        .useAutoLayout()
        .fixed(side: 56)
        .with {
            $0.backgroundColor = .lightGray
            $0.layer.with {
                $0.cornerRadius = 56 / 2
                $0.borderColor = UIColor.gray.cgColor
                $0.borderWidth = 1
                $0.masksToBounds = true
            }
        }

    private func commonInit() {
        UIView.hStack(
            [
                avatarImage,
                userNameLabel,
            ],
            spacing: 8,
            alignment: .center
        ).wrap(horizontal: 16, vertical: 10)
            .add(to: contentView)
            .fillParent()
    }

    func fill(with user: UserListItemViewModel) {
        userNameLabel.text = user.userName
        avatarImage.kf.setImage(with: URL(string: user.avatar))
    }
}
