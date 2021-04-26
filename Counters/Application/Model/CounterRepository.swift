//
//  CounterRepository.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

class CounterRepository: Repository {

    // MARK: - Properties

    typealias Entity = CounterModelProtocol
    
    private let api: APIHandler

    // MARK: - Initialization

    init(api: APIHandler){
        self.api = api
    }

    // MARK: - Public Methods

    func getCounters(completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        let apiTaskLoader = NetworkingClientLoader(apiRequest: api)

        apiTaskLoader.loadAPIRequest(requestData: .getCounters) { (result) in
            completionHandler(result)
        }
    }

    func createCounter(name: String,
                       completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        let apiTaskLoader = NetworkingClientLoader(apiRequest: api)

        apiTaskLoader.loadAPIRequest(requestData: .createCounter(name: name)) { (result) in
            completionHandler(result)
        }
    }

    func increaseCounter(id: String,
                       completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        let apiTaskLoader = NetworkingClientLoader(apiRequest: api)

        apiTaskLoader.loadAPIRequest(requestData: .increaseCounter(id: id)) { (result) in
            completionHandler(result)
        }
    }

    func decreaseCounter(id: String,
                         completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        let apiTaskLoader = NetworkingClientLoader(apiRequest: api)

        apiTaskLoader.loadAPIRequest(requestData: .decreaseCounter(id: id)) { (result) in
            completionHandler(result)
        }
    }

    func deleteCounter(id: String,
                         completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        let apiTaskLoader = NetworkingClientLoader(apiRequest: api)

        apiTaskLoader.loadAPIRequest(requestData: .deleteCounter(id: id)) { (result) in
            completionHandler(result)
        }
    }
}
