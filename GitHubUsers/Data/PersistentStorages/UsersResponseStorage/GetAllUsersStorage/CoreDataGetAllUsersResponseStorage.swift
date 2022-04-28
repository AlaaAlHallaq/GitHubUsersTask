//
//  CoreDataGetAllUsersResponseStorage.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import CoreData

final class CoreDataGetAllUsersResponseStorage {
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private
}

extension CoreDataGetAllUsersResponseStorage: GetAllUsersResponseStorage {
    func getResponse(completion: @escaping (Result<GetAllUsersResponseDTO, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

                let results = try context.fetch(fetchRequest).map { $0.toDTO() }

                completion(.success(results))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(response responseDto: GetAllUsersResponseDTO, completion: @escaping (Result<Void, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                try context.execute(deleteRequest)
                try context.save()

                for user in responseDto {
                    let _ = user.toEntity(in: context)
                }

                try context.save()

                completion(.success(()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataUsersResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
