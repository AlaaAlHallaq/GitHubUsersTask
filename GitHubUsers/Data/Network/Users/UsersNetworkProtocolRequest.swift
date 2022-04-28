//
//  UsersNetworkProtocolRequest.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
protocol UsersNetworkProtocolRequest {
    /// Get comment data by status and date
    func getAllUsers(
        since: Int,
        completion: @escaping (Result<GetAllUsersResponseDTO, CustomError>) -> Void
    )
    func getUserDetails(
        userName: String,
        completion: @escaping (Result<GetUserDetailsResponseDTO, CustomError>) -> Void
    )
}
