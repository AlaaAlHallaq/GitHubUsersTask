//
//  PersistenceAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Foundation
import Swinject

class PersistenceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetAllUsersResponseStorage.self) { resolver in
            let request = CoreDataGetAllUsersResponseStorage(
                coreDataStorage: CoreDataStorage.shared
            )
            return request
        }.inObjectScope(.transient)

        container.register(GetUserDetailsResponseStorage.self) { resolver in
            let request = CoreGetUserDetailsResponseStorage(
                coreDataStorage: .shared
            )
            return request
        }.inObjectScope(.transient)

    }
}
