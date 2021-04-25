//
//  NetworkingClient.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

struct NetworkingClient: APIHandler {
    
    var client = Networking()

    let reachibility: Reachability = Reachability()!

    func makeRequest(from route: Route) throws -> URLRequest {
        guard let requestURL = URL(string: route.path) else {
            throw NSError()
        }

        return client.makeRequest(with: requestURL, httpMethod: route.method.rawValue, parameters: route.parameters) as URLRequest
    }

    func parseResponse(data: Data) throws -> [CounterModelProtocol] {
        return try defaultParseResponse(data: data)
    }
}

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
                    completionHandler(.failure(error ?? NSError()))
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
