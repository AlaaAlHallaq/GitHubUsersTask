//
//  UsersDetailsViewModel.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

protocol UsersDetailsViewModelInput {
    func updateUser(user: User)
}

protocol UsersDetailsViewModelOutput {
    var user: Observable<UserDetails?> { get }
}

protocol UsersDetailsViewModel: UsersDetailsViewModelInput, UsersDetailsViewModelOutput {}

class DefaultUsersDetailsViewModel: UsersDetailsViewModel {
    private let getUserDetailsUseCase: GetUserDetailsUseCase
    init(getUserDetailsUseCase: GetUserDetailsUseCase) {
        self.getUserDetailsUseCase = getUserDetailsUseCase
    }

    let user: Observable<UserDetails?> = .init(nil)
}

extension DefaultUsersDetailsViewModel {
    func updateUser(user: User) {
        let completion = { (result: Result<UserDetails?, Error>) in
            switch result {
            case .success(let userDetails):
                DispatchQueue.main.async {
                    self.user.value = userDetails
                }
            case .failure: break
            }
        }
        getUserDetailsUseCase.execute(
            input: .init(user: user),
            completion: completion
        )
    }
}
