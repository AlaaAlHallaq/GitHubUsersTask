//
//  NetworkAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Foundation

import Swinject

class NetworkAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(UsersNetworkProtocolRequest.self) { resolver in
            let request = UserNetworkRequest()
            return request
        }.inObjectScope(.transient)
        
        
    }
    
}
