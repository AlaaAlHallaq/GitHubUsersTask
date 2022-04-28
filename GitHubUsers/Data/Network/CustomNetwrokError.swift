//
//  CustomNetwrokError.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

enum CustomError: Error {
    case requestError(error:Error)
    case failedHttpRequest(response:HTTPURLResponse?)
    case emptyResponse
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case canceled
}
