//
//  CounterRepositoryTests.swift
//  CountersTests
//
//  Created by David A Cespedes R on 4/26/21.
//

import XCTest
@testable import Counters

class CounterRepositoryTests: XCTestCase {

    private var apiLoader: APILoader!

    struct Constants {
        static let createCounterJSON =
        """
        [
            {
                "id": "knw0iw9g",
                "title": "Coffe",
                "count": 0
            }
        ]
        """

        static let increaseCounterJSON =
        """
        [
            {
                "id": "knw0iw9g",
                "title": "Coffe",
                "count": 1
            }
        ]
        """

        static let decreaseCounterJSON =
        """
        [
            {
                "id": "knw0iw9g",
                "title": "Coffe",
                "count": 0
            }
        ]
        """
    }

    override func setUpWithError() throws {
        apiLoader = NetworkingClientLoaderMock()
    }

    func testInitWithApiMock() throws {
        // Given
        let repository: CounterRepository

        // When
        repository = CounterRepository(apiTaskLoader: apiLoader)

        // Then
        XCTAssertNotNil(repository)
    }

    func testGetCountersWithApiMock() throws {
        // Given
        let repository = CounterRepository(apiTaskLoader: apiLoader)
        let expectation = XCTestExpectation(description: "response")
        guard let expectedCountersData = try JSONLoaderHelper.loadJSONToData(fileName: "CountersJSONExample"),
              let expectedCounters = try NetworkingClient().parseResponse(data: expectedCountersData) as? [CounterModel] else {
            XCTFail("Could not parse expected Counters")
            return
        }


        // When
        repository.getCounters { (result) in
            switch result {
            case .success(let counters):
                // Then
                guard let counters = counters else {
                    XCTFail("No Counters")
                    return
                }
                XCTAssertNotNil(counters)
                XCTAssertEqual(counters.count, expectedCounters.count)
                XCTAssertEqual(counters.first!.id, expectedCounters.first!.id)
                XCTAssertEqual(counters.last!.id, expectedCounters.last!.id)
            case .failure(let error):
                print("The error is: \(error)")
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
    }

    func testCreateCounterWithApiMock() throws {
        // Given
        let repository = CounterRepository(apiTaskLoader: apiLoader)
        let expectation = XCTestExpectation(description: "response")
        let jsonData: Data = Constants.createCounterJSON.data(using: .utf8)!
        guard let expectedCounters = try NetworkingClient().parseResponse(data: jsonData) as? [CounterModel] else {
            XCTFail("Could not parse expected Counters")
            return
        }

        // When
        repository.createCounter(name: "Coffe") { (result) in
            switch result {
            case .success(let counters):
                // Then
                guard let counters = counters else {
                    XCTFail("No Counters")
                    return
                }
                XCTAssertNotNil(counters)
                XCTAssertEqual(counters.count, expectedCounters.count)
                XCTAssertEqual(counters.first!.id, expectedCounters.first!.id)
                XCTAssertEqual(counters.first!.title, expectedCounters.first!.title)
                XCTAssertEqual(counters.first!.title, "Coffe")
            case .failure(let error):
                print("The error is: \(error)")
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
    }

    func testIncreaseCounterWithApiMock() throws {
        // Given
        let idToIncrease = "knw0iw9g"
        let repository = CounterRepository(apiTaskLoader: apiLoader)
        let expectation = XCTestExpectation(description: "response")
        let jsonData: Data = Constants.increaseCounterJSON.data(using: .utf8)!
        guard let expectedCounters = try NetworkingClient().parseResponse(data: jsonData) as? [CounterModel] else {
            XCTFail("Could not parse expected Counters")
            return
        }

        // When
        repository.increaseCounter(id: idToIncrease) { (result) in
            switch result {
            case .success(let counters):
                // Then
                guard let counters = counters else {
                    XCTFail("No Counters")
                    return
                }
                XCTAssertNotNil(counters)
                XCTAssertEqual(counters.count, expectedCounters.count)
                XCTAssertEqual(counters.first!.id, expectedCounters.first!.id)
                XCTAssertEqual(counters.first!.title, expectedCounters.first!.title)
                XCTAssertEqual(counters.first!.id, idToIncrease)
                XCTAssertEqual(counters.first!.count, 1)
            case .failure(let error):
                print("The error is: \(error)")
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
    }

    func testDecreaseCounterWithApiMock() throws {
        // Given
        let idToDecrease = "knw0iw9g"
        let repository = CounterRepository(apiTaskLoader: apiLoader)
        let expectation = XCTestExpectation(description: "response")
        let jsonData: Data = Constants.decreaseCounterJSON.data(using: .utf8)!
        guard let expectedCounters = try NetworkingClient().parseResponse(data: jsonData) as? [CounterModel] else {
            XCTFail("Could not parse expected Counters")
            return
        }

        // When
        repository.decreaseCounter(id: idToDecrease) { (result) in
            switch result {
            case .success(let counters):
                // Then
                guard let counters = counters else {
                    XCTFail("No Counters")
                    return
                }
                XCTAssertNotNil(counters)
                XCTAssertEqual(counters.count, expectedCounters.count)
                XCTAssertEqual(counters.first!.id, expectedCounters.first!.id)
                XCTAssertEqual(counters.first!.title, expectedCounters.first!.title)
                XCTAssertEqual(counters.first!.id, idToDecrease)
                XCTAssertEqual(counters.first!.count, 0)
            case .failure(let error):
                print("The error is: \(error)")
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
    }

    func testDeleteCounterWithApiMock() throws {
        // Given
        let idToDelete = "AnyOtherId"
        let repository = CounterRepository(apiTaskLoader: apiLoader)
        let expectation = XCTestExpectation(description: "response")
        let jsonData: Data = Constants.increaseCounterJSON.data(using: .utf8)!
        guard let expectedCounters = try NetworkingClient().parseResponse(data: jsonData) as? [CounterModel] else {
            XCTFail("Could not parse expected Counters")
            return
        }

        // When
        repository.deleteCounter(id: idToDelete) { (result) in
            switch result {
            case .success(let counters):
                // Then
                guard let counters = counters else {
                    XCTFail("No Counters")
                    return
                }
                XCTAssertNotNil(counters)
                XCTAssertEqual(counters.count, expectedCounters.count)
                XCTAssertEqual(counters.first!.id, expectedCounters.first!.id)
                XCTAssertEqual(counters.first!.title, expectedCounters.first!.title)
                XCTAssertNotEqual(counters.first!.id, idToDelete)
                XCTAssertNotEqual(counters.first!.count, 0)
            case .failure(let error):
                print("The error is: \(error)")
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
    }
}
