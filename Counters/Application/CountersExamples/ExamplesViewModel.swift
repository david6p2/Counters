//
//  ExamplesViewModel.swift
//  Counters
//
//  Created by David A Cespedes R on 5/1/21.
//

import Foundation

struct ExamplesViewModel {

    // MARK: - Section View Model

    /// ViewModel for each section of the Examples
    struct ExamplesSectionViewModel {

        /// Section Title
        let sectionTitle: String

        /// Section Example items
        let sectionExamples: [String]
    }

    // MARK: - Properties
    
    let examplesHeaderString: String
    let examplesViewModel: [ExamplesSectionViewModel]
}
