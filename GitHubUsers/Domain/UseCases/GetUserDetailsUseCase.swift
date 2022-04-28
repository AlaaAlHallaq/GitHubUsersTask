//
//  GetUserDetailsUseCase.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

protocol GetUserDetailsUseCase {
    func execute(input: GetUserDetailsInput, completion: @escaping (Result<UserDetails?, Error>) -> Void)
}

struct GetUserDetailsInput {
    let user: User
}

final class DefaultGetUserDetailsUseCase: GetUserDetailsUseCase {
    private let repository: UsersDetailsRepository

    init(repository: UsersDetailsRepository) {
        self.repository = repository
    }

    func execute(input: GetUserDetailsInput, completion: @escaping (Result<UserDetails?, Error>) -> Void) {
        repository.getUserDetailsRemote(userName: input.user.login ?? "") { [weak self] result in

            guard let self = self else {
                completion(.failure(CustomError.canceled))
                return
            }
            switch result {
            case .success(let items):

                self.repository.saveUserDetailsLocale(item: items) { _ in
                    completion(.success(items))
                }

            case .failure:
                _ = self.repository.getUserDetailsLocale(id: input.user.id ?? 0) {
                    completion($0)
                }
            }
        }
    }
}
