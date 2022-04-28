//
//  UsersListItemViewModel.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
struct UsersListViewModelActions {
    let showUserDetails: (User) -> Void
}

protocol UsersListViewModelInput {
    func viewWillAppear()
    func nextPage()
    func didSelect(item: UserListItemViewModel)
}

protocol UsersListViewModelOutput {
    var items: Observable<[UserListItemViewModel]> { get }
}

protocol UsersListViewModel: UsersListViewModelInput, UsersListViewModelOutput {}

final class DefaultUsersListViewModel: UsersListViewModel {
    private let getAllUsersUseCase: GetAllUsersUseCase
    private let actions: UsersListViewModelActions?

    // MARK: - OUTPUT

    let items: Observable<[UserListItemViewModel]> = Observable([])

    private var isLoading = false

    init(
        getAllUsersUseCase: GetAllUsersUseCase,
        actions: UsersListViewModelActions? = nil
    ) {
        self.getAllUsersUseCase = getAllUsersUseCase
        self.actions = actions
    }

    private func updateUsers() {
        let completion: (Result<[User], Error>) -> Void = { result in
            switch result {
            case .success(let items):
                self.updateItems(items)
            case .failure: break
            }
        }
        getAllUsersUseCase.execute(
            input: .init(sinceID: 0),
            completion: completion
        )
    }

    private func updateItems(_ user: [User], append: Bool = false) {
        items.value = (append ? items.value : []) + user.map {
            .init(user: $0)
        }
    }

    func nextPage() {
        if isLoading { return }
        let completion: (Result<[User], Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let items):
                self?.updateItems(items, append: true)
            case .failure: break
            }
            self?.isLoading = false
        }

        let larges = items
            .value
            .map { $0.user.id ?? 0
            }.max() ?? 0

        isLoading = true

        getAllUsersUseCase.execute(
            input: .init(sinceID: larges + 1),
            completion: completion
        )
    }
}

// MARK: - INPUT. View event methods

extension DefaultUsersListViewModel {
    func viewWillAppear() {
        updateUsers()
    }

    func didSelect(item: UserListItemViewModel) {
        actions?.showUserDetails(item.user)
    }
}
