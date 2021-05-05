//
//  CounterCellViewModel.swift
//  Counters
//
//  Created by David A Cespedes R on 5/5/21.
//

import Foundation

struct CounterCellViewModel {
    private let counterModel: CounterModel!
    let id: String
    let name: String
    let count: Int

    init(counterModel: CounterModel) {
        self.counterModel = counterModel
        self.id = counterModel.id
        self.name = counterModel.title
        self.count = counterModel.count
    }

    func getModel() -> CounterModel {
        return counterModel
    }
}

extension CounterCellViewModel: Hashable { }
