//
//  UseCaseAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Foundation
import Swinject

class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetAllUsersUseCase.self) { resolver in

            guard let repository = resolver.resolve(UsersRepository.self) else {
                fatalError("Assembler was unable to resolve UsersRepository")
            }

            return DefaultGetAllUsersUseCase(repository: repository)
        }.inObjectScope(.transient)

        container.register(GetUserDetailsUseCase.self) { resolver in

            guard let repository = resolver.resolve(UsersDetailsRepository.self) else {
                fatalError("Assembler was unable to resolve UsersDetailsRepository")
            }

            return DefaultGetUserDetailsUseCase(repository: repository)
        }.inObjectScope(.transient)
    }
}
