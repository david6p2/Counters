//
//  CounterModelProtocol.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import Foundation

/// Model Protocol used to represent a counter
protocol CounterModelProtocol {
    /// Counter ID
    var id: String { set get }
    /// Counter title (name)
    var title: String { set get }
    /// Current counter count
    var count: Int { set get }
}
