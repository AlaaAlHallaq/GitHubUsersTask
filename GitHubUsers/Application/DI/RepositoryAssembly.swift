//
//  RepositoryAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Foundation
import Swinject

class RepositoryAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(UsersRepository.self) { resolver in
            
            guard let api = resolver.resolve(UsersNetworkProtocolRequest.self) else {
                fatalError("Assembler was unable to resolve UsersNetworkProtocolRequest")
            }
       
            guard let cache = resolver.resolve(GetAllUsersResponseStorage.self) else {
                fatalError("Assembler was unable to resolve GetAllUsersResponseStorage")
            }
            
            return DefaultUsersRepository(cache: cache, api: api)
        }.inObjectScope(.transient)
        
        
        
        container.register(UsersDetailsRepository.self) { resolver in
            
            guard let api = resolver.resolve(UsersNetworkProtocolRequest.self) else {
                fatalError("Assembler was unable to resolve UsersNetworkProtocolRequest")
            }
       
            guard let cache = resolver.resolve(GetUserDetailsResponseStorage.self) else {
                fatalError("Assembler was unable to resolve GetUserDetailsResponseStorage")
            }
            
            
            return DefaultUsersDetailsRepository(cache: cache, api: api)
        }.inObjectScope(.transient)
        
        
        
    }
    
}
