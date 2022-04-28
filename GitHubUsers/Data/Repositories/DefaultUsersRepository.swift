//
//  UsersRepository.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

final class DefaultUsersRepository {
    private let cache: GetAllUsersResponseStorage
    private let api: UsersNetworkProtocolRequest

    init(cache: GetAllUsersResponseStorage, api: UsersNetworkProtocolRequest) {
        self.cache = cache
        self.api = api
    }
}

extension DefaultUsersRepository: UsersRepository {
    func getAllUsersRemote(since: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        api.getAllUsers(since: since) { result in

            switch result {
            case let .success(response):
                completion(.success(response.map { $0.toDomain() }))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getAllUsersLocale(completion: @escaping (Result<[User], Error>) -> Void) {
        cache.getResponse() { result in

            switch result {
            case let .success(response):
                completion(.success(response.map { $0.toDomain() }))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func saveUsersLocale(items: [User], completion: @escaping (Result<Void, Error>) -> Void) {
        self.cache.save(
            response: items.map({ $0.toDTO() }),
            completion: { result in

                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
}
