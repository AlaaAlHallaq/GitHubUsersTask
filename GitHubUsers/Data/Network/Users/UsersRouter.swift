//
//  UsersRouter.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import Alamofire

enum UsersRouter: APIConfiguration {
    case getAllUsers(since: Int)
    case getUser(userName: String)

    var baseURL: URL {
        return AppConfigurations.githubApiBaseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllUsers:
            return .get
        case .getUser:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getAllUsers:
            return "/users"
        case let .getUser(userName):
            return "/users/\(userName)"
        }
    }

    var queryItems: Parameters? {
        switch self {
        case let .getAllUsers(since):
            return ["since": since]
        case .getUser:
            return nil
        }
    }

    var parameters: Parameters? {
        return nil
    }
}
