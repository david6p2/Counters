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
    associatedtype RequestDataType

    var client: Networking { get }

    func makeRequest(from data: RequestDataType) throws -> URLRequest
}

protocol ResponseHandler {
    associatedtype ResponseDataType

    func parseResponse(data: Data) throws -> ResponseDataType
}

typealias APIHandler = RequestHandler & ResponseHandler


extension ResponseHandler {
    /// Default response data parser
    func defaultParseResponse(data: Data) throws -> [CounterModel] {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        if let body = try? jsonDecoder.decode([CounterModel].self, from: data) {
            return body
        } else {
            throw UnknownParseError(message: "Error Parsing Data")
        }
    }
}

