//
//  LoginViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 9/6/22.
//

import Combine
import Networking
import Foundation
import SharedKit

class LoginViewModel: BaseViewModel {

    private var service: AuthorizationService

    // Outputs
    @Published var email = LocalStorageManager.shared.retrieve(forKey: .email, type: String.self) ?? ""
    @Published var password = LocalStorageManager.shared.retrieve(forKey: .password, type: String.self) ?? ""
    @Published var loaderVisibility: Bool = false
    @Published var userIsEligible: Bool = false
    @Published var errorMessage: String?

    init(service: AuthorizationService = DataManager.shared) {
        self.service = service

        super.init()
    }

    var validatedEmail: AnyPublisher<String?, Never> {
        return $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                return email.isEmailValid() ? email : nil
            }
            .eraseToAnyPublisher()
    }

    var validatedPassword: AnyPublisher<String?, Never> {
        return $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password in
                return password.isPasswordValid() ? password : nil
            }
            .eraseToAnyPublisher()
    }

    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        return Publishers.CombineLatest(validatedEmail, validatedPassword)
            .receive(on: RunLoop.main)
            .map { email, password in
                guard let _email = email,
                      let _password = password else {
                    return nil
                }
                return (_email, _password)
            }
            .eraseToAnyPublisher()
    }

    /// Login user api call.
    func loginUser() {
        loaderVisibility = true
        service.login(email: email, password: password)
            .compactMap {
                UserDataManager.shared.updateUser($0)
                return !$0.memberId.isEmpty
            }
            .subscribe(on: RunLoop.main)
            .catch({ [weak self] error -> Just<Bool> in
                if case .invalidServerResponseWithStatusCode(let code) = error, code == 404 {
                    self?.errorMessage = "You have entered an invalid username or password"
                } else {
                    self?.errorMessage = error.errorDescription
                }

                self?.handleCredentials(store: false)
                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$userIsEligible)
    }

    /// Save or Delete Credentials from local cache
    /// - Parameter store: Whether user has selected rememberMe checkbox.
    func handleCredentials(store: Bool) {
        if store {
            LocalStorageManager.shared.save(email, forKey: .email, withMethod: .userDefaults)
            LocalStorageManager.shared.save(password, forKey: .password, withMethod: .userDefaults)
        } else {
            LocalStorageManager.shared.removeKey(.email)
            LocalStorageManager.shared.removeKey(.password)
        }
    }

}
