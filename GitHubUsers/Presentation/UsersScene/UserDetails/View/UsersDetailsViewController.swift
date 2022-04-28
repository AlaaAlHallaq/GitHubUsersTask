//
//  UsersDetailsViewController.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import UIKit
class UsersDetailsViewController: UIViewController {
    var user: User?

    private var viewModel: UsersDetailsViewModel!

    static func create(with viewModel: UsersDetailsViewModel) -> UsersDetailsViewController {
        let view = UsersDetailsViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        setupUI()
    }

    private func bind(to viewModel: UsersDetailsViewModel) {
        viewModel.user.observe(on: self) { [weak self] values in
            guard let self = self else { return }
            self.userName.text = values?.name ?? values?.login
            self.avatarImage.kf.setImage(
                with: URL(string: values?.avatarURL ?? "")
            )
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = user {
            viewModel.updateUser(user: user)
        }
    }

    let avatarImage = UIImageView()
        .useAutoLayout()
        .fixed(side: 200.screenFactored)
        .with {
            $0.layer.with {
                $0.cornerRadius = (200 / 2).screenFactored
                $0.masksToBounds = true
                $0.borderWidth = 1
                $0.borderColor = UIColor.gray.cgColor
                $0.backgroundColor = UIColor.lightGray.cgColor
            }
        }

    let userName = UILabel()
        .useAutoLayout()
        .with {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20, weight: .regular)
        }

    func setupUI() {
        view.backgroundColor = .white
        UIView.vStack(
            [
                avatarImage,
                userName,
            ],
            alignment: .center
        )
        .addToVerticalScrollView()
        .add(to: self.view)
        .fillParent()

        self.title = user?.login ?? ""
    }
}

// adhoc extension
extension CGFloat {
    var screenFactored: CGFloat {
        self * UIScreen.main.bounds.width / 375
    }
}

extension Int {
    var screenFactored: CGFloat {
        CGFloat(self) * UIScreen.main.bounds.width / 375
    }
}
