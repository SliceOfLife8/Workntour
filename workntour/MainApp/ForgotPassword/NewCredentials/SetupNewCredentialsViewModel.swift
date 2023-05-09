//
//  SetupNewCredentialsViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 9/1/23.
//

import Foundation
import Combine

class SetupNewCredentialsViewModel: BaseViewModel {

    // MARK: - Properties

    private var service: AuthorizationService

    var data: DataModel

    // Outputs
    @Published var passwordLengthIsValid: Bool = false
    @Published var passwordContainsUpperCaseLetter: Bool = false
    @Published var passwordContainsLowerCaseLetter: Bool = false
    @Published var passwordContainsNumAndSpecialChar: Bool = false

    @Published var passwordChanged: Bool = false

    // MARK: - Constructors/Destructors

    required init(
        service: AuthorizationService = DataManager.shared,
        data: DataModel
    ) {
        self.service = service
        self.data = data
    }

    var validatePasswords: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(
            $passwordLengthIsValid,
            $passwordContainsUpperCaseLetter,
            $passwordContainsLowerCaseLetter,
            $passwordContainsNumAndSpecialChar
        )
        .receive(on: RunLoop.main)
        .map { length, upperCase, lowerCase, numAndSpecial in
            guard length, upperCase, lowerCase, numAndSpecial
            else {
                return false
            }
            return true
        }
        .eraseToAnyPublisher()
    }

    func passwordValidation(_ password: String) {
        // Contains at least 8 characters
        passwordLengthIsValid = password.count >= 8 ? true : false
        // Contains at least one upper case
        let predicateUpperCaseChars = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*")
        passwordContainsUpperCaseLetter = predicateUpperCaseChars.evaluate(with: password)
        // Contains at least one lower case
        let predicateLowerCaseChars = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*")
        passwordContainsLowerCaseLetter = predicateLowerCaseChars.evaluate(with: password)
        // Contains at least one digit and a special character
        let predicateNumAndSpecialChars = NSPredicate(format:"SELF MATCHES %@", "^(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{2,}$")
        passwordContainsNumAndSpecialChar = predicateNumAndSpecialChars.evaluate(with: password)
    }

    func updateCredentials(_ newPassword: String) {
        service.updatePassword(
            .init(token: data.token, password: newPassword)
        )
        .subscribe(on: DispatchQueue.main)
        .catch({ _ -> Just<Bool> in
            return Just(false)
        })
            .assign(to: &$passwordChanged)
    }
}

// MARK: - DataModel
extension SetupNewCredentialsViewModel {

    class DataModel {

        // MARK: - Properties

        let token: String

        // MARK: - Constructors/Destructors

        init(token: String) {
            self.token = token
        }
    }
}