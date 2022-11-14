//
//  LanguagePickerViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 14/11/22.
//

import Foundation

class LanguagePickerViewModel: BaseViewModel {
    /// Inputs
    @Published var language: (Language, Proficiency)?
    /// Outputs
    var data: DataModel

    // MARK: - Init

    required init(data: DataModel) {
        self.data = data
    }
}

// MARK: - LanguagePickerViewModel.DataModel
extension LanguagePickerViewModel {

    enum Proficiency: String, CaseIterable {
        case beginner
        case intermediate
        case fluent

        var value: String {
            switch self {
            case .beginner:
                return "Beginner"
            case .intermediate:
                return "Intermediate"
            case .fluent:
                return "Fluent"
            }
        }
    }

    class DataModel {

        // MARK: - Properties

        let languages: [Language]
        let proficiencies: [Proficiency]

        // MARK: - Constructors/Destructors

        init(languages: [Language], proficiencies: [Proficiency]) {
            self.languages = languages
            self.proficiencies = proficiencies
        }
    }
}
