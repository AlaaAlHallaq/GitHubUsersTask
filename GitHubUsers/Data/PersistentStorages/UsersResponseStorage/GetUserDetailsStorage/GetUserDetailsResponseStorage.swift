//
//  GetUserDetailsResponseStorage.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

protocol GetUserDetailsResponseStorage {
    func getResponse(id:Int, completion: @escaping (Result<GetUserDetailsResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: GetUserDetailsResponseDTO, completion: @escaping (Result<Void, CoreDataStorageError>) -> Void)
}
