//
//  GetAllUsersUseCase.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

protocol GetAllUsersUseCase {
    func execute(input: GetAllUsersInput, completion: @escaping (Result<[User], Error>) -> Void)
}

struct GetAllUsersInput {
    let sinceID: Int
}

final class DefaultGetAllUsersUseCase: GetAllUsersUseCase {
    private let repository: UsersRepository

    init(repository: UsersRepository) {
        self.repository = repository
    }

    func execute(input: GetAllUsersInput, completion: @escaping (Result<[User], Error>) -> Void) {
        repository.getAllUsersRemote(since: input.sinceID) { [weak self] result in
            
            guard let self = self else {
                completion(.failure(CustomError.canceled))
                return
            }
            switch result {
            case .success(let items):
                if input.sinceID == 0 {
                    self.repository.saveUsersLocale(items: items) { _ in
                        completion(result)
                    }
                } else {
                    completion(result)
                }

            case .failure:
                if input.sinceID == 0 {
                    _ = self.repository.getAllUsersLocale {
                        completion($0)
                    }
                } else {
                    completion(result)
                }
            }
        }
    }
}
