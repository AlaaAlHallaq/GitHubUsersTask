//
//  GetAllUsersResponseStorage.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

protocol GetAllUsersResponseStorage {
    func getResponse(completion: @escaping (Result<GetAllUsersResponseDTO, CoreDataStorageError>) -> Void)
    func save(response: GetAllUsersResponseDTO, completion: @escaping (Result<Void, CoreDataStorageError>) -> Void)
}
