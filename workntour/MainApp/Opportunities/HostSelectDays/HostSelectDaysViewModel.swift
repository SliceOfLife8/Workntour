//
//  HostSelectDaysViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 22/1/23.
//

import Foundation
import Combine

// MARK: - HostSelectDaysViewModel
class HostSelectDaysViewModel: BaseViewModel {

    // MARK: - Properties

    var dataModel: DataModel

    @Published var minimumDays: Int?
    @Published var maximumDays: Int?
    @Published var maxWorkingHours: Int?
    @Published var daysOff: Int?

    // MARK: - Constructors/Destructors

    init(dataModel: DataModel) {
        self.dataModel = dataModel
        self.minimumDays = dataModel.dates?.minimumDays
        self.maximumDays = dataModel.dates?.maximumDays
        self.maxWorkingHours = dataModel.dates?.maxWorkingHours
        self.daysOff = dataModel.dates?.daysOff
    }

    var validateData: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(
            $minimumDays,
            $maximumDays,
            $maxWorkingHours,
            $daysOff
        )
        .receive(on: RunLoop.main)
        .map { minDays, maxDays, workingHours, daysOff in
            guard minDays != nil,
                  maxDays != nil,
                  workingHours != nil,
                  daysOff != nil
            else {
                return false
            }
            return true
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - DataModel
extension HostSelectDaysViewModel {

    class DataModel {

        // MARK: - Properties

        let dates: OpportunitySelectDates?

        // MARK: - Constructors/Destructors

        init(dates: OpportunitySelectDates?) {
            self.dates = dates
        }
    }
}
