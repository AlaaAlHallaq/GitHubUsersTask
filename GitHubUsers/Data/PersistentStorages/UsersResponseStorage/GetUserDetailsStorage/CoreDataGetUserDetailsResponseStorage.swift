//
//  CoreDataGetUserDetailsResponseStorage.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import CoreData

final class CoreGetUserDetailsResponseStorage {
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private
}

extension CoreGetUserDetailsResponseStorage: GetUserDetailsResponseStorage {
    func getResponse(id: Int, completion: @escaping (Result<GetUserDetailsResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest<UserDetailsEntity> = UserDetailsEntity.fetchRequest()

                let predicate = NSPredicate(format: "id = %d", id)

                fetchRequest.predicate = predicate

                let results = try context.fetch(fetchRequest).map { $0.toDTO() }

                completion(.success(results.first))

            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(response responseDto: GetUserDetailsResponseDTO, completion: @escaping (Result<Void, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetailsEntity")

                deleteFetch.predicate = NSPredicate(format: "id = %d", responseDto.id ?? -1)

                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                try context.execute(deleteRequest)
                try context.save()

                _ = responseDto.toEntity(in: context)

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
