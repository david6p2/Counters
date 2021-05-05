//
//  Repository.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

protocol Repository {
    /// Entity used by the Repository
    associatedtype Entity


    /// Get all the current Counters
    /// - Parameter completionHandler: Returns a Result with the Counters array if it is successful or an error if it fails
    func getCounters(completionHandler: @escaping (Result<[Entity]?, Error>) -> Void)


    /// Create a new Countter
    /// - Parameters:
    ///   - name: The name of the counter to be created
    ///   - completionHandler: Returns a Result with the Counters array, including the one created, if it is successful or an error if it fails
    func createCounter(_ counter: Entity,
                       completionHandler: @escaping (Result<[Entity]?, Error>) -> Void)


    /// Increase the count of the Counter passed by paramenter
    /// - Parameters:
    ///   - id: the id of the counter that wants to be increased
    ///   - completionHandler: Returns a Result with the Counters array, including the one increased, if it is successful or an error if it fails
    func increaseCounter(id: String,
                         completionHandler: @escaping (Result<[Entity]?, Error>) -> Void)


    /// Decrease the count of the Counter passed by paramenter
    /// - Parameters:
    ///   - id: the id of the counter that wants to be decrease
    ///   - completionHandler: Returns a Result with the Counters array, including the one decrease, if it is successful or an error if it fails
    func decreaseCounter(id: String,
                         completionHandler: @escaping (Result<[Entity]?, Error>) -> Void)


    /// Delete the counter passed by parameter
    /// - Parameters:
    ///   - id: the id of the counter that wants to be deleted
    ///   - completionHandler: Returns a Result with the current Counters array, not including the one deleted, if it is successful or an error if it fails
    func deleteCounter(id: String,
                       completionHandler: @escaping (Result<[Entity]?, Error>) -> Void)
}
