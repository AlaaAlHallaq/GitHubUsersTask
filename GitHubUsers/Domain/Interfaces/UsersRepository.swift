//
//  UsersRepository.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

protocol UsersRepository {
    func getAllUsersRemote(since: Int, completion: @escaping (Result<[User], Error>) -> Void)
    
    func getAllUsersLocale(completion: @escaping (Result<[User], Error>) -> Void)
    
    
    func saveUsersLocale(items: [User], completion: @escaping (Result<Void, Error>) -> Void)
    
}
