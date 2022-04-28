//
//  UsersDetailsRepository.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

protocol UsersDetailsRepository {
    func getUserDetailsRemote(userName: String, completion: @escaping (Result<UserDetails, Error>) -> Void)

    func getUserDetailsLocale(id: Int, completion: @escaping (Result<UserDetails?, Error>) -> Void) 

    func saveUserDetailsLocale(item: UserDetails, completion: @escaping (Result<Void, Error>) -> Void)
    
}
