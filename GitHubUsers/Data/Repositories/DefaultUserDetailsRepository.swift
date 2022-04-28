//
//  UserDetailsRepository.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

final class DefaultUsersDetailsRepository {
    private let cache: GetUserDetailsResponseStorage
    private let api: UsersNetworkProtocolRequest

    init(cache: GetUserDetailsResponseStorage, api: UsersNetworkProtocolRequest) {
        self.cache = cache
        self.api = api
    }
}

extension DefaultUsersDetailsRepository: UsersDetailsRepository {
    func getUserDetailsRemote(userName: String, completion: @escaping (Result<UserDetails, Error>) -> Void)   {

        api.getUserDetails(userName: userName) { result in
            switch result {
            case let .success(response):
                completion(.success(response.toDomain()))
            case let .failure(error):
                completion(.failure(error))
            }
        }

        
    }

    func getUserDetailsLocale(id: Int, completion: @escaping (Result<UserDetails?, Error>) -> Void)  {
         
        cache.getResponse(id: id) { result in

            switch result {
            case let .success(response):
                completion(.success(response?.toDomain()))
            case let .failure(error):
                completion(.failure(error))
            }
        }

        
    }

    func saveUserDetailsLocale(item: UserDetails, completion: @escaping (Result<Void, Error>) -> Void) {
        self.cache.save(response: item.toDTO()) { result in

            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
