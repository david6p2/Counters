//
//  CounterModel.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import Foundation

/// Concrete implementation of the CounterModelProtocol
struct CounterModel: CounterModelProtocol {
    var id: String
    var title: String
    var count: Int
}

extension CounterModel: Decodable {}
