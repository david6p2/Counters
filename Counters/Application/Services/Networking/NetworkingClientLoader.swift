//
//  NetworkingClientLoader.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

class NetworkingClientLoader<T: APIHandler> {

    let apiRequest: T

    let reachibility: Reachability

    init(apiRequest: T, reachibility: Reachability = Reachability()!) {
        self.apiRequest = apiRequest
        self.reachibility = reachibility
    }

    func loadAPIRequest(requestData: T.RequestDataType,
                        completionHandler: @escaping (Result<T.ResponseDataType?, Error>) -> ()) {
        // Check network status
        if reachibility.connection == .none {
            return completionHandler(.failure(NetworkError(message: "No Internet Connection")))
        }

        // Prepare url request
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)

            // Do Data task request
            apiRequest.client.dataRequestURL(urlRequest) { (data, error) in
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }

                guard let data = data else {
                    completionHandler(.failure(NSError(domain: CountersErrorDomain,
                                                       code: CountersErrorCode.noData.rawValue,
                                                       userInfo: nil)
                    ))
                    return
                }
                // Parse response
                do {
                    let parsedResponse = try self.apiRequest.parseResponse(data: data)
                    return completionHandler(.success(parsedResponse))
                } catch {
                    return completionHandler(.failure(error))
                }
            }.resume()
        } catch {
            completionHandler(.failure(error))
            return
        }
    }
}
