//
//  ViewModelAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Foundation
import Swinject
class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UsersListViewModel.self) { resolver in

            guard let getAllUsersUseCase = resolver.resolve(GetAllUsersUseCase.self) else {
                fatalError("Assembler was unable to resolve GetAllUsersUseCase")
            }
            guard let actions = resolver.resolve(UsersListViewModelActions.self) else {
                fatalError("Assembler was unable to resolve UsersListViewModelActions")
            }

            return DefaultUsersListViewModel.init(
                getAllUsersUseCase: getAllUsersUseCase,
                actions: actions
            )

        }.inObjectScope(.transient)

        container.register(UsersDetailsViewModel.self) { resolver in

            guard let getUserDetailsUseCase = resolver.resolve(GetUserDetailsUseCase.self) else {
                fatalError("Assembler was unable to resolve GetUserDetailsUseCase")
            }

            return DefaultUsersDetailsViewModel(
                getUserDetailsUseCase: getUserDetailsUseCase
            )

        }.inObjectScope(.transient)
    }
}
