//
//  APIHandler.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

// MARK: - Errors

struct NetworkError: Error {
    let message: String
}

struct UnknownParseError: Error {
    let message: String
}

// MARK: - APIHandler

protocol  RequestHandler {
    var client: Networking { get }

    func makeRequest(from route: Route) throws -> URLRequest
}

protocol ResponseHandler {
    func parseResponse(data: Data) throws -> [CounterModelProtocol]
}

typealias APIHandler = RequestHandler & ResponseHandler


extension ResponseHandler {
    /// Default response data parser
    func defaultParseResponse(data: Data) throws -> [CounterModel] {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            return try jsonDecoder.decode([CounterModel].self, from: data)
        } catch let error as NSError {
            throw error
        } catch {
            throw UnknownParseError(message: "Error Parsing Data")
        }
    }
}

