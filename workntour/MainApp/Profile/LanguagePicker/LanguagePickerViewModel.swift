//
//  LanguagePickerViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 14/11/22.
//

import Foundation

class LanguagePickerViewModel: BaseViewModel {
    /// Inputs
    @Published var language: ProfileLanguage?
    var lang: Language?
    var prof: LanguageProficiency?
    /// Outputs
    @Published var editLanguage: ProfileLanguage?
    var data: DataModel
    var profileDto: TravelerProfileDto?

    // MARK: - Init

    required init(data: DataModel) {
        self.data = data
        self.language = data.editLanguage
        self.editLanguage = data.editLanguage
        self.profileDto = UserDataManager.shared.retrieve(TravelerProfileDto.self)
    }

    func updateLanguage(_ lang: Language) {
        self.lang = lang
        guard let prof else { return }
        self.language = ProfileLanguage(language: lang, proficiency: prof)
    }

    func updateLanguageProficiency(_ prof: LanguageProficiency) {
        self.prof = prof
        guard let lang else { return }
        self.language = ProfileLanguage(language: lang, proficiency: prof)
    }
}

// MARK: - LanguagePickerViewModel.DataModel
extension LanguagePickerViewModel {

    class DataModel {

        enum Mode {
            case add
            case edit
        }

        // MARK: - Properties

        let languages: [Language]
        let proficiencies: [LanguageProficiency]
        let mode: Mode
        let editLanguage: ProfileLanguage?

        // MARK: - Constructors/Destructors

        init(
            exludeLanguages: [Language],
            editLanguage: ProfileLanguage? = nil
        ) {
            self.languages = Language.allCases.filter { !exludeLanguages.contains($0) }
            self.proficiencies = LanguageProficiency.allCases
            self.editLanguage = editLanguage
            self.mode = editLanguage != nil ? .edit : .add
        }
    }
}
