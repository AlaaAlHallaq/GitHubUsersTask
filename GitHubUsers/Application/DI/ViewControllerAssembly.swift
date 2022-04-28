//
//  ViewControllerAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Foundation
import Swinject

class ViewControllerAssembly: Assembly {
    
    enum ViewControllerIds: String {
        case posts_list_vc
        case post_details_vc
    }
    
    func assemble(container: Container) {
        
        container.register(UsersListViewController.self) { resolver in
            
            guard let viewModel = resolver.resolve(UsersListViewModel.self) else {
                fatalError("Assembler was unable to resolve PostsListViewModel")
            }
            
            return UsersListViewController.create(with: viewModel)
           
        }.inObjectScope(.transient)
        
        container.register(UsersDetailsViewController.self) { resolver in
            
            guard let viewModel = resolver.resolve(UsersDetailsViewModel.self) else {
                fatalError("Assembler was unable to resolve UsersDetailsViewModel")
            }
            
            return UsersDetailsViewController.create(with: viewModel)
           
        }.inObjectScope(.transient)
    }
}
