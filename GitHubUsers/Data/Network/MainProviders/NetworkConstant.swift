//
//  APIConfiguration.swift
//  APIConfiguration
//
//  Created by AlaaHallaq on 27/04/2022.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
}


enum ContentType: String {
    case all = "*/*"
    case json = "application/json"
    case xForm = "application/x-www-form-urlencoded"
}

