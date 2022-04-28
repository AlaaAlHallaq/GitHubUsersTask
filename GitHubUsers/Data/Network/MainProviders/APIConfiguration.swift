//
//  APIConfiguration.swift
//  APIConfiguration
//
//  Created by AlaaHallaq on 27/04/2022.
//

import Foundation
import Alamofire
/**
 This is the base protocol used to configure all API router object
 */
protocol APIConfiguration: URLRequestConvertible, URLConvertible {
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: Parameters? { get }
    var parameters: Parameters? { get }
}

extension APIConfiguration {
    func asURL() throws -> URL {
        guard
            var url = URLComponents(
                url: baseURL
                    .appendingPathComponent(path),
                resolvingAgainstBaseURL: false
            )
        else {
            throw AFError.invalidURL(url: self)
        }

        url.queryItems = self.queryItems?.map { (k, v) in
            URLQueryItem(name: k, value: "\(v)")
        }

        guard let result = url.url else {
            throw AFError.invalidURL(url: self)
        }

        return result
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: try asURL())

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(
            ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue
        )

        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(
                    withJSONObject: parameters,
                    options: []
                )
            } catch {
                throw AFError.parameterEncodingFailed(
                    reason: .jsonEncodingFailed(
                        error: error
                    )
                )
            }
        }

        return urlRequest
    }
}
