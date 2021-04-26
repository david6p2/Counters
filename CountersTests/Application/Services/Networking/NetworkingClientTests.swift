//
//  NetworkingClientTests.swift
//  CountersTests
//
//  Created by David A Cespedes R on 4/25/21.
//

import XCTest
@testable import Counters

class NetworkingClientTests: XCTestCase {

    let request = NetworkingClient()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeRequestWithGetCounters() {
        // Given
        let route = Route.getCounters

        // When
        do {
            let urlRequest = try request.makeRequest(from: route)
            // Then
            XCTAssertEqual(urlRequest.httpMethod, "GET")
            XCTAssertNil(urlRequest.httpBody)
            XCTAssertEqual(urlRequest.url?.absoluteString, route.path)
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields)
            XCTAssertLessThanOrEqual(urlRequest.allHTTPHeaderFields!.count, 1)
        } catch  {
            XCTFail("Couldn't make request")
        }
    }

    func testMakeRequestWithCreateCounter() {
        // Given
        let route = Route.createCounter(name: "AnyName")

        // When
        do {
            let urlRequest = try request.makeRequest(from: route)
            // Then
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertNotNil(urlRequest.httpBody)
            XCTAssertEqual(urlRequest.url?.absoluteString, route.path)
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields)
            XCTAssertLessThanOrEqual(urlRequest.allHTTPHeaderFields!.count, 1)
        } catch  {
            XCTFail("Couldn't make request")
        }
    }


    func testParseResponseWithSuccessfulResponse() {
        // Given
        let sampleResponse =
        """
        [
           {
              "id": "asdf",
              "title": "Coffee",
              "count": 1
           }
        ]
        """
        let jsonData = sampleResponse.data(using: .utf8)!

        do {
            let response = try request.parseResponse(data: jsonData)
            XCTAssertEqual(response.first?.id, "asdf")
        } catch {
            XCTFail("Couln't parse response")
        }
    }

    func testParseResponseWithFailureResponse() {
        // Given
        let sampleResponse =
            """
        {
          "id": "asdf",
          "title": "Coffee",
          "count": 1
        }
        """
        let jsonData = sampleResponse.data(using: .utf8)!

        do {
            let response = try request.parseResponse(data: jsonData)
            XCTFail("Shouldn't be able to parse invalid JSON srtucture \(response)")
        } catch let error as UnknownParseError {
            XCTAssertEqual(error.message, "Error Parsing Data")
        } catch {
            XCTFail("Should have thrown an UnknownParseError")
        }
    }
}
