//
//  MainCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import UIKit
import SharedKit
import AuthenticationServices

enum MainStep: Step {
    case registrationPoint
    case login
    case loginAsGuest
    case appleLogin
    case googleLogin
    case showGenericAlert(title: String, subtitle: String?)
}

// MARK: - MainCoordinator
final class MainCoordinator: NSObject, NavigationCoordinator {
    
    var parent: AppCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController
    
    init(parent: AppCoordinator) {
        self.parent = parent
        
        let navigationController = UINavigationController()
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }
    
    func start() {
        let splashViewModel = SplashViewModel()
        let splashVC = SplashVC()
        
        splashVC.viewModel = splashViewModel
        splashVC.coordinator = self
        
        navigator.push(splashVC, animated: false)
    }
    
    func navigate(to step: MainStep) {
        switch step {
        case .showGenericAlert(let title, let subtitle):
            AlertHelper.showDefaultAlert(
                rootViewController,
                title: title,
                message: subtitle
            )
        case .registrationPoint:
            showAlert()
        case .login:
            startLoginFlow()
        case .loginAsGuest:
            showMainFlow()
        case .appleLogin:
            loginInWithAppleId()
        case .googleLogin:
            print("Google login!")
        }
    }
    
    func showAlert() {
        AlertHelper.showAlertWithTwoActions(
            rootViewController,
            title: "sign_up_as".localized(),
            hasCancelOption: true,
            leftButtonTitle: "traveler".localized(),
            rightButtonTitle: "host".localized(),
            leftAction: {
                self.startRegistrationFlow(forType: .TRAVELER)
            }, rightAction: {
                self.startRegistrationFlow(forType: .INDIVIDUAL_HOST)
            })
    }
    
    private func startRegistrationFlow(forType type: UserRole) {
        let registrationCoordinator = RegistrationCoordinator(parent: self, role: type)
        presentCoordinator(registrationCoordinator, modalStyle: .overFullScreen, animated: true)
    }
    
    private func startLoginFlow() {
        let loginCoordinator = LoginCoordinator(parent: self)
        pushCoordinator(loginCoordinator, animated: true)
    }
    
    /// Create TabBarCoordinator & set it as rootViewController of our main NavigationController
    func showMainFlow() {
        // rootViewController.hideNavigationBar(false)
        let tabCoordinator = TabBarCoordinator(parent: self, rootViewController)
        pushCoordinator(tabCoordinator, animated: false)
        navigator.setRootViewController(tabCoordinator.rootViewController, animated: false)
    }

    private func loginInWithAppleId() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])

        controller.delegate = self
        controller.presentationContextProvider = self

        controller.performRequests()
    }

    /// f.e. appleSub `000154.93d183be76c244b0a1ccf6dfb101cc6f.0721`
    private func performSiwaAuth(with appleSub: String) {
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: appleSub) { [weak self] state, error in
            switch state {
            case .authorized:
                print("Account Found - Signed In")
                DispatchQueue.main.async {
                    // self.showUserViewController(scene: windowScene)
                }
            default:
                print("clear cache & throw error")
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension MainCoordinator: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user

            print("user: \(userIdentifier)")
            break
        default:
            break
        }
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("handle me: \(error)")
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension MainCoordinator: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return SceneDelegate.shared!.window!
    }
}
