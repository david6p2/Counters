//
//  ExamplesViewDelegate.swift
//  Counters
//
//  Created by David A Cespedes R on 5/2/21.
//

import UIKit

/// ExamplesViewDelegate with ExamplesView actions
protocol ExamplesViewDelegate: class {
    func oneOfTheExamplesWasTapped(with name: String)
}
