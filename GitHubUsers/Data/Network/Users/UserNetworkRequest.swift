//
//  UserNetworkRequest.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

class UserNetworkRequest: UsersNetworkProtocolRequest {
    func getAllUsers(since: Int, completion: @escaping (Result<GetAllUsersResponseDTO, CustomError>) -> Void) {
        let router = UsersRouter.getAllUsers(since: since)
        _ = NetworkRequestPerfomer.performRequest(
            route: router,
            completion: completion
        )
    }

    func getUserDetails(userName: String, completion: @escaping (Result<GetUserDetailsResponseDTO, CustomError>) -> Void) {
        let router = UsersRouter.getUser(userName: userName)
        _ = NetworkRequestPerfomer.performRequest(
            route: router,
            completion: completion
        )
    }
}
