//
//  NetworkingClientLoaderMock.swift
//  CountersTests
//
//  Created by David A Cespedes R on 4/26/21.
//

import Foundation
@testable import Counters

class NetworkingClientLoaderMock: APILoader {
    let apiRequest = NetworkingClient()

    func loadAPIRequest(requestData: Route,
                        completionHandler: @escaping (Result<[CounterModel]?, Error>) -> ()) {
        switch requestData {
        case .getCounters:
            do {
                let jsonData: Data = try JSONLoaderHelper.loadJSONToData(fileName: "CountersJSONExample")!
                let parsedResponse = try self.apiRequest.parseResponse(data: jsonData)
                return completionHandler(.success(parsedResponse))
            } catch {
                return completionHandler(.failure(error))
            }
        case .createCounter(let name):
            do {
                let sampleResponse =
                """
                [
                    {
                        "id": "knw0iw9g",
                        "title": "\(name)",
                        "count": 0
                    }
                ]
                """
                let jsonData: Data = sampleResponse.data(using: .utf8)!
                let parsedResponse = try self.apiRequest.parseResponse(data: jsonData)
                return completionHandler(.success(parsedResponse))
            } catch {
                return completionHandler(.failure(error))
            }
        case .increaseCounter(let id):
            do {
                let sampleResponse =
                """
                [
                    {
                        "id": "\(id)",
                        "title": "Coffe",
                        "count": 1
                    }
                ]
                """
                let jsonData: Data = sampleResponse.data(using: .utf8)!
                let parsedResponse = try self.apiRequest.parseResponse(data: jsonData)
                return completionHandler(.success(parsedResponse))
            } catch {
                return completionHandler(.failure(error))
            }
        case .decreaseCounter(let id):
            do {
                let sampleResponse =
                """
                [
                    {
                        "id": "\(id)",
                        "title": "Coffe",
                        "count": 0
                    }
                ]
                """
                let jsonData: Data = sampleResponse.data(using: .utf8)!
                let parsedResponse = try self.apiRequest.parseResponse(data: jsonData)
                return completionHandler(.success(parsedResponse))
            } catch {
                return completionHandler(.failure(error))
            }
        case .deleteCounter:
            do {
                let sampleResponse =
                """
                [
                    {
                        "id": "knw0iw9g",
                        "title": "Coffe",
                        "count": 1
                    }
                ]
                """
                let jsonData: Data = sampleResponse.data(using: .utf8)!
                let parsedResponse = try self.apiRequest.parseResponse(data: jsonData)
                return completionHandler(.success(parsedResponse))
            } catch {
                return completionHandler(.failure(error))
            }
        }
    }
}

