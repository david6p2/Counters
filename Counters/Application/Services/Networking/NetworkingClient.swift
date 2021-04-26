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
            throw client.error(CountersErrorCode.invalidURL)
        }

        return client.makeRequest(with: requestURL, httpMethod: route.method.rawValue, parameters: route.parameters) as URLRequest
    }

    func parseResponse(data: Data) throws -> [CounterModelProtocol] {
        return try defaultParseResponse(data: data)
    }
}
