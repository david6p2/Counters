//
//  CounterModelTests.swift
//  CountersTests
//
//  Created by David A Cespedes R on 4/26/21.
//

import XCTest
@testable import Counters

class CounterModelTests: XCTestCase {

    func testCounterModelInitializationWhenParsedFromJSON() throws {
        // Given
        do {
            let jsonData: Data = try JSONLoaderHelper.loadJSONToData(fileName: "CounterJSONExample")!
            let jsonDict: [String:Any] = try JSONLoaderHelper.loadJSONToDictionary(fileName: "CounterJSONExample")!
            var model: CounterModelProtocol

            // When
            model = try! JSONDecoder().decode(CounterModel.self, from: jsonData)

            // Then
            XCTAssertNotNil(model)
            XCTAssertEqual(model.id, jsonDict["id"] as! String)
            XCTAssertEqual(model.title, jsonDict["title"] as! String)
            XCTAssertEqual(model.count, jsonDict["count"] as! Int)
        } catch {
            XCTFail("Could not even parse the JSON Files")
        }
    }

}
