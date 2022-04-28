//
//  UsersFlowCoordinator.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import UIKit
import Swinject

class UsersFlowCoordinator {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    var usersListViewModelActions: UsersListViewModelActions {
        .init(showUserDetails: showUserDetails(user:))
    }

    func start() {
        Assembler.sharedContainer.register(UsersListViewModelActions.self) { _ in
            self.usersListViewModelActions
        }

        let resolver = Assembler.sharedAssembler.resolver
        if let usersListViewController = resolver.resolve(UsersListViewController.self) {
            self.navigationController?.pushViewController(usersListViewController, animated: true)
        } else {
            fatalError("could not resolve UsersListViewController")
        }
    }

    private func showUserDetails(user: User) {
        let resolver = Assembler.sharedAssembler.resolver
        if let usersDetailsViewController = resolver.resolve(UsersDetailsViewController.self) {
            usersDetailsViewController.user = user

            self.navigationController?.pushViewController(
                usersDetailsViewController,
                animated: true
            )
        } else {
            fatalError("could not resolve UsersListViewController")
        }
    }
}
