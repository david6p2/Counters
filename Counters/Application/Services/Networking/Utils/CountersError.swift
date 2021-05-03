//
//  CountersError.swift
//  Counters
//
//  Created by David A Cespedes R on 5/3/21.
//

import UIKit

struct CountersError: Error {
    enum ErrorType {
        case get
        case add(name: String)
        case increase(id: String)
        case decrease(id: String)
        case delete(id: String)
    }

    let error: NSError
    let type: ErrorType
    let title: String?
    let message: String?
    let actionTitle: String?
    let retryTitle: String?
    let handler: ((UIAlertAction) -> Void)?
}
