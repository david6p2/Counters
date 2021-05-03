//
//  CountersBoardNoContentViewDelegate.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import Foundation

/// NoContentView actions
protocol CountersBoardNoContentViewDelegate: class {
    func noContentButtonPressed(with type: CountersBoardNoContentView.NoContentViewType)
}
