//
//  JSONLoaderHelper.swift
//  Counters
//
//  Created by David A Cespedes R on 4/26/21.
//

import Foundation

class JSONLoaderHelper {
    enum Constants: String {
        case errorDomain = "counters.localLoding.error.domain"
        case messageKey = "message"
        case messageValue = "No JSON filename found in bundle"
        case messageValueDictionary = "Could not transform Data into a Dictionary"
    }

    /// Load any JSON file from a given filename and return its Data. If it fails it will throw an error.
    /// - Parameter fileName: the JSON filename to load
    /// - Throws: the NSError if it fails to load the JSON file
    /// - Returns: The Data of the loaded JSON file
    public func loadJSON(fileName: String) throws ->  Data? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: Constants.errorDomain.rawValue,
                    code: -1,
                    userInfo: [Constants.messageKey.rawValue: Constants.messageValue.rawValue])
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            let errorDesc = error as NSError
            throw errorDesc
        }
    }

    /// Load any JSON file from a given filename and return its parsed Dictionary. If it fails it will throw an error.
    /// - Parameter fileName: the JSON filename to load
    /// - Throws: the NSError if it fails to load the JSON file
    /// - Returns: The Dictionary of the loaded JSON file
    public func loadJSON(fileName: String) throws ->  [String: Any]? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: Constants.errorDomain.rawValue,
                          code: -1,
                          userInfo: [Constants.messageKey.rawValue: Constants.messageValue.rawValue])
        }
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            guard let jsonResult = json as? [String: AnyObject] else {
                throw NSError(domain: Constants.errorDomain.rawValue,
                              code: -2,
                              userInfo: [Constants.messageKey.rawValue: Constants.messageValueDictionary.rawValue])
            }

            return jsonResult
        } catch {
            let errorDesc = error as NSError
            throw errorDesc
        }
    }
}



