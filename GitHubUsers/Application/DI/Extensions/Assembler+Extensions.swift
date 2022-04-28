//
//  Assembler+Extensions.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Foundation
import Swinject

extension Assembler {
    
    static let sharedContainer = Container()
    static let sharedAssembler: Assembler = {
        
        let assembler = Assembler([
            ViewControllerAssembly(),
            ViewModelAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            NetworkAssembly(),
            PersistenceAssembly()
        ], container: sharedContainer)
        
        return assembler
    }()
}
