//
//  CounterRepository.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

class CounterRepository: Repository {

    // MARK: - Properties

    typealias Entity = CounterModel
    
    private let apiTaskLoader: APILoader

    // MARK: - Initialization

    init(apiTaskLoader: APILoader){
        self.apiTaskLoader = apiTaskLoader
    }

    // MARK: - Public Methods

    func getCounters(completionHandler: @escaping (Result<[CounterModel]?, Error>) -> Void) {
        apiTaskLoader.loadAPIRequest(requestData: .getCounters) { (result) in
            completionHandler(result)
        }
    }

    func createCounter(_ counter: CounterModel,
                       completionHandler: @escaping (Result<[CounterModel]?, Error>) -> Void) {
        apiTaskLoader.loadAPIRequest(requestData: .createCounter(name: counter.title)) { (result) in
            completionHandler(result)
        }
    }

    func increaseCounter(id: String,
                       completionHandler: @escaping (Result<[CounterModel]?, Error>) -> Void) {
        apiTaskLoader.loadAPIRequest(requestData: .increaseCounter(id: id)) { (result) in
            completionHandler(result)
        }
    }

    func decreaseCounter(id: String,
                         completionHandler: @escaping (Result<[CounterModel]?, Error>) -> Void) {
        apiTaskLoader.loadAPIRequest(requestData: .decreaseCounter(id: id)) { (result) in
            completionHandler(result)
        }
    }

    func deleteCounter(id: String,
                         completionHandler: @escaping (Result<[CounterModel]?, Error>) -> Void) {
        apiTaskLoader.loadAPIRequest(requestData: .deleteCounter(id: id)) { (result) in
            completionHandler(result)
        }
    }
}
