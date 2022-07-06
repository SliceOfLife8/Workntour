//
//  DataManager.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import Combine
import Networking

/// Data Manager acts as a middle layer (abstraction) between the service(s) and our application.
/// ViewModels are responsible to communite with this layer and pass the data back to Views.
class DataManager {
    static let shared = DataManager()

    private(set) var networking: Networking

    init(networking: Networking = Networking(),
         debugEnabled: Bool = true) {
        self.networking = networking
        self.networking.preference.isDebuggingEnabled = debugEnabled
    }
}

// MARK: - AuthorizationService
extension DataManager: AuthorizationService {

    func travelerRegistration(model: Traveler) -> AnyPublisher<String?, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerTraveler(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<Traveler>.self)
        .map { $0.data?.email }
        .eraseToAnyPublisher()
    }

    func individualHostRegistration(model: IndividualHost) -> AnyPublisher<String?, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerHostIndividual(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<IndividualHost>.self)
        .map { $0.data?.email }
        .eraseToAnyPublisher()
    }

    func companyHostRegistration(model: CompanyHost) -> AnyPublisher<String?, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerHostCompany(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<CompanyHost>.self)
        .map { $0.data?.email }
        .eraseToAnyPublisher()
    }

    func login(email: String, password: String) -> AnyPublisher<LoginModel, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.login(email: email, password: password),
            scheduler: DispatchQueue.main,
            class: GenericResponse<LoginModel>.self)
        .compactMap { $0.data }
        .eraseToAnyPublisher()
    }

}

// MARK: - ProfileService
extension DataManager: ProfileService {

    func getTravelerProfile(memberId: String) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: ProfileRouter.getTraveler(memberId),
            scheduler: DispatchQueue.main,
            class: GenericResponse<TravelerProfile>.self)
        .compactMap {
            UserDataManager.shared.save($0.data,
                                        memberId: $0.data?.memberID,
                                        role: $0.data?.role)
            return $0.data != nil
        }
        .eraseToAnyPublisher()
    }

    func getIndividualHostProfile(memberId: String) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: ProfileRouter.getIndividualHost(memberId),
            scheduler: DispatchQueue.main,
            class: GenericResponse<IndividualHostProfile>.self)
        .compactMap {
            UserDataManager.shared.save($0.data,
                                        memberId: $0.data?.memberID,
                                        role: $0.data?.role)
            return $0.data != nil
        }
        .eraseToAnyPublisher()
    }

    func getCompanyHostProfile(memberId: String) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: ProfileRouter.getCompanyHost(memberId),
            scheduler: DispatchQueue.main,
            class: GenericResponse<CompanyHostProfile>.self)
        .compactMap {
            UserDataManager.shared.save($0.data,
                                        memberId: $0.data?.memberID,
                                        role: $0.data?.role)
            return $0.data != nil
        }
        .eraseToAnyPublisher()
    }

}

// MARK: - ProfileService
extension DataManager: OpportunityService {

    func createOpportunity(_ model: OpportunityDto) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: OpportunityRouter.createOpportunity(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<OpportunityDto>.self)
        .compactMap { $0.data != nil }
        .eraseToAnyPublisher()
    }

    func getOpportunities(id: String) -> AnyPublisher<[OpportunityDto], ProviderError> {
        return networking.request(
            with: OpportunityRouter.getOpportunities(id: id),
            scheduler: DispatchQueue.main,
            class: GenericResponse<[OpportunityDto]>.self)
        .compactMap { $0.data }
        .eraseToAnyPublisher()
    }

}
