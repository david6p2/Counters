//
//  CounterRepository.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

class CounterRepository {

    func getCounters(completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        // API
        let api = NetworkingClient()

        // API Loader
        let apiTaskLoader = NetworkingClientLoader(apiRequest: api)

        apiTaskLoader.loadAPIRequest(requestData: .getCounters) { (result) in
            completionHandler(result)
        }
    }
}
