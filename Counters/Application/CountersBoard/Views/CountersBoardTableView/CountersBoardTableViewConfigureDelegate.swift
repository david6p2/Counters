//
//  CountersBoardTableViewConfigureDelegate.swift
//  Counters
//
//  Created by David A Cespedes R on 4/24/21.
//

import Foundation

/// ConfigureDelegate to tell the DataSource when the table is ready to be configured
protocol CountersBoardTableViewConfigureDelegate: class {

    /// Method to call when the table needs to be configured
    /// - Parameter counters: The Counters Model Array that is going to be used to build the table
    func isCallingConfigure(with counters: [CounterModelProtocol], animated: Bool)
}
