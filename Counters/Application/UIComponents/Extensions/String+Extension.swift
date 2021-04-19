//
//  String+Extension.swift
//  Counters
//
//  Created by David A Cespedes R on 4/18/21.
//

import Foundation

/// `String` extension
extension String {

    /// Search for a localized `String` using `self` as key
    /// - Parameter comment: comment to help localize the `String`
    /// - Returns: The localized `String` if there is one or an empty `String`.
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
