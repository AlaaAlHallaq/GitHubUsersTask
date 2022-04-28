//
//  AppConfigurations.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation


enum AppConfigurations {
    /// Get base url value
    static var githubApiBaseURL: URL {
        var baseEndpoint = ""
        do {
            baseEndpoint = try Configuration.value(for: "ApiBaseURL") as String
        } catch(let error) {
            print("Error :\(error)")
            baseEndpoint = "https://"
        }
        return URL(string: baseEndpoint)!
    }
    

}


enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

