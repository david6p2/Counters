//
//  CounterModel.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import Foundation

/// Counter Model to parse the response from the API and store in the DB
struct CounterModel {
    var id: String
    var title: String
    var count: Int
}

extension CounterModel: Decodable {}
extension CounterModel: Hashable {}
