//
//  ProfileLanguage.swift
//  workntour
//
//  Created by Chris Petimezas on 19/11/22.
//

import Foundation
import CommonUI

struct ProfileLanguage: Codable, Equatable {
    let language: Language
    let proficiency: LanguageProficiency

    func convertToCommonUI() -> ProfileLanguageCell.DataModel.ProfileLanguageUI {
        return .init(
            language: language.value,
            proficiency: proficiency.value
        )
    }
}

enum LanguageMode {
    case add
    case edit
    case delete
}
