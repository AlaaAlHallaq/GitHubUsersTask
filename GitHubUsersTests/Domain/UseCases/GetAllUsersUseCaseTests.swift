//
//  GitHubUsersTests.swift
//  GitHubUsersTests
//
//  Created by AlaaHallaq on 28/04/2022.
//

import XCTest
@testable import GitHubUsers

import XCTest

class GetAllUsersUseCaseTests: XCTestCase {
    static let users: [User] = {
        let user1 = User(
            id: 1,
            login: "AlaaHallaq",
            nodeID: "",
            avatarURL: "",
            gravatarID: "",
            url: "",
            htmlURL: "",
            followersURL: "",
            followingURL: "",
            gistsURL: "",
            starredURL: "",
            subscriptionsURL: "",
            organizationsURL: "",
            reposURL: "",
            eventsURL: "",
            receivedEventsURL: "",
            type: "",
            siteAdmin: false
        )
        return [user1]
    }()

    enum UsersRepositorySuccessTestError: Error {
        case failedFetching
    }

    class UsersRepositoryMock: UsersRepository {
        var usersCache: [User] = []

        var lastCall: Int = 0

        var resultAPI: Result<[User], Error>

        init(resultAPI: Result<[User], Error>) {
            self.resultAPI = resultAPI
        }

        func getAllUsersLocale(completion: @escaping (Result<[User], Error>) -> Void) {
            completion(.success(usersCache))
        }

        func getAllUsersRemote(since: Int, completion: @escaping (Result<[User], Error>) -> Void) {
            completion(resultAPI)
        }

        func saveUsersLocale(items: [User], completion: @escaping (Result<Void, Error>) -> Void) {
            self.usersCache = items
            completion(.success(()))
        }
    }

    func testGetAllUsersUseCase_whenSuccessfullyFetchesUsersFromAPI_thenUsersAreSavedInDB() {
        // given
        let expectation = self.expectation(description: "Recent Users saved")

        expectation.expectedFulfillmentCount = 2

        let resultAPI = Result<[User], Error>.success(GetAllUsersUseCaseTests.users)

        let usersRepositoryMock = UsersRepositoryMock(resultAPI: resultAPI)

        let useCase = DefaultGetAllUsersUseCase(repository: usersRepositoryMock)

        // when

        useCase.execute(input: .init(sinceID: 0)) { _ in
            expectation.fulfill()
        }
        // then
        var recents = [User]()
        usersRepositoryMock.getAllUsersLocale() { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        let expected = User(
            id: 1,
            login: "AlaaHallaq",
            nodeID: "",
            avatarURL: "",
            gravatarID: "",
            url: "",
            htmlURL: "",
            followersURL: "",
            followingURL: "",
            gistsURL: "",
            starredURL: "",
            subscriptionsURL: "",
            organizationsURL: "",
            reposURL: "",
            eventsURL: "",
            receivedEventsURL: "",
            type: "",
            siteAdmin: false
        )
        XCTAssertTrue(recents.contains(expected))
    }
 
}
