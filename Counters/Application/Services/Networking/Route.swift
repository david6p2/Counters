//
//  Route.swift
//  Counters
//
//  Created by David A Cespedes R on 4/25/21.
//

import Foundation

/// Routes to make Network Request
enum Route {
    case getCounters
    case createCounter(name: String)
    case increaseCounter(id: String)
    case decreaseCounter(id: String)
    case deleteCounter(id: String)
}

// MARK: - Private Constants

private extension Route {

    var baseURL: String {
        return Constants.baseDomain + Constants.basePath
    }

    enum Constants {
        static let baseDomain = "http://127.0.0.1:3000"
        static let basePath = "/api/v1/"
    }

    struct Path {
        static let counter =    "counter/"
        static let counters =   "counters"
        static let increase =   "inc"
        static let decrease =   "dec"
    }

    struct Body {
        static let idKey =      "id"
        static let titleKey =    "title"
    }
}

extension Route {
    enum HTTPMethod : String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    var method: HTTPMethod {
        switch self {
        case .getCounters:
            return .get
        case .createCounter, .increaseCounter, .decreaseCounter:
            return .post
        case .deleteCounter:
            return .delete
        }
    }

    var path: String {
        switch self {
        case .getCounters:
            return baseURL + Path.counters
        case .createCounter, .deleteCounter:
            return baseURL + Path.counter
        case .increaseCounter:
            return baseURL + Path.counter + Path.increase
        case .decreaseCounter:
            return baseURL + Path.counter + Path.decrease
        }
    }

    var parameters: [String: String]? {
        switch self {
        case .createCounter(let name):
            return [Body.titleKey: name]
        case .deleteCounter(let id), .increaseCounter(let id), .decreaseCounter(let id):
            return [Body.idKey: id]
        default:
            return nil
        }
    }
}
