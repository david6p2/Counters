//
//  KeyValueStorageProtocol.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import Foundation

// Keys to be used in the KeyValue Storage
enum OnboardingKey: String {
    case welcomeWasShown
}

public protocol KeyValueStorageProtocol {
    func string(forKey: String) -> String?
    func bool(forKey: String) -> Bool
    func set(_ value: Bool, forKey defaultName: String)
}

extension UserDefaults: KeyValueStorageProtocol {}
