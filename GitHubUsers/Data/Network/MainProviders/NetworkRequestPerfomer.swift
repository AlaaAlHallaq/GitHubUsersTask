//
//  NetworkRequestPerfomer.swift
//  NetworkRequestPerfomer
//
//  Created by AlaaHallaq on 27/04/2022.
//

import Foundation
import Alamofire

class NetworkRequestPerfomer {
    /// A generic network request performer for execute all request for router that extends APIConfiguration
    /// - Parameters:
    ///   - route: Router object
    ///   - success: success operation
    ///   - failure: fail operation
    /// - Returns: Current network operation request
    public static func performRequest<T: Decodable>(route: APIConfiguration, completion: @escaping (Result<T, CustomError>) -> Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable { (response: DataResponse<T, AFError>) in
                do {
                    if let error = response.error {
                        let localizedDesctiptionError: String = error.localizedDescription
                        if response.data != nil {
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data response: \(utf8Text)")
                            }
                        } else {
                            print("Error: \(localizedDesctiptionError)")
                        }
                        completion(.failure(CustomError.requestError(error: error)))
                    } else {
                        if let responseData = response.data {
                            debugPrint("Data response: \(responseData)")

                            let statusCode = response.response?.statusCode

                            if let statusCode = statusCode, statusCode < 300, statusCode >= 200 {
                                completion(.success(try JSONDecoder().decode(T.self, from: responseData)))
                            } else {
                                completion(
                                    .failure(
                                        CustomError.failedHttpRequest(
                                            response: response.response
                                        )
                                    )
                                )
                            }

                        } else {
                            completion(.failure(CustomError.emptyResponse))
                        }
                    }
                } catch {
                    completion(.failure(CustomError.requestError(error: error)))
                }
            }
    }
}
