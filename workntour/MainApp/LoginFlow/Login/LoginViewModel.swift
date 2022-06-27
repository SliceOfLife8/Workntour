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
    // Services
    private var authorizationService: AuthorizationService
    private var profileService: ProfileService

    // Outputs
    @Published var email = LocalStorageManager.shared.retrieve(forKey: .email, type: String.self) ?? ""
    @Published var password = LocalStorageManager.shared.retrieve(forKey: .password, type: String.self) ?? ""
    @Published var loaderVisibility: Bool = false
    @Published var userLoggedIn: LoginModel?
    @Published var userIsEligible: Bool = false
    @Published var errorMessage: String?

    init(authorizationService: AuthorizationService = DataManager.shared,
         profileService: ProfileService = DataManager.shared) {
        self.authorizationService = authorizationService
        self.profileService = profileService

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
        authorizationService.login(email: email, password: password)
            .compactMap { $0 }
            .subscribe(on: RunLoop.main)
            .catch({ [weak self] error -> Just<LoginModel?> in
                if case .invalidServerResponseWithStatusCode(let code) = error, code == 404 {
                    self?.errorMessage = "You have entered an invalid username or password"
                } else {
                    self?.errorMessage = error.errorDescription
                }

                self?.handleCredentials(store: false)
                self?.loaderVisibility = false
                return Just(nil)
            })
                .assign(to: &$userLoggedIn)
    }

    func retrieveProfile(_ model: LoginModel) {
        let profilePublisher: AnyPublisher<Bool, ProviderError>

        switch model.role {
        case .TRAVELER:
            profilePublisher = profileService.getTravelerProfile(memberId: model.memberId)
        case .INDIVIDUAL_HOST:
            profilePublisher = profileService.getIndividualHostProfile(memberId: model.memberId)
        case .COMPANY_HOST:
            profilePublisher = profileService.getCompanyHostProfile(memberId: model.memberId)
        }

        profilePublisher
            .subscribe(on: RunLoop.main)
            .catch({ [weak self] error -> Just<Bool> in
                self?.errorMessage = error.errorDescription

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
