//
//  NetworkingClient.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

struct NetworkingClient {
    private var client = Networking()

    private func url(for path: String) -> URL {
        URL(string: baseURL + path)!
    }

    func getCounters(completionHandler: @escaping (Result<[CounterModel], Error>) -> Void) {
        client.dataRequest(url(for: "/api/v1/counters"),
                           httpMethod: "GET",
                           parameters: nil) { (data, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            if let data = data {
                let response = Result {
                    try JSONDecoder.init().decode([CounterModel].self, from: data)
                }
                completionHandler(response)
            }
        }.resume()
    }
}

enum Route {
    case getCounters
    case createCounter(name: String)
    case increaseCounter(id: String)
    case decreaseCoounter(id: String)
    case deleteCounter(id: String)
}
