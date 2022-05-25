//
//  AuthorizationRouter.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 2/5/22.
//

import Foundation
import Networking

enum AuthorizationRouter: NetworkTarget {
    case registerTraveler(_ traveler: Traveler)
    case registerHostIndividual(_ individual: IndividualHost)
    case registerHostCompany(_ company: CompanyHost)

    public var baseURL: URL {
        Environment.current.apiBaseURL
    }

    public var path: String {
        switch self {
        case .registerTraveler:
            return "/registration/traveler"
        case .registerHostIndividual:
            return "/registration/host/individual"
        case .registerHostCompany:
            return "registration/host/company"
        }
    }

    public var methodType: MethodType {
        .post
    }

    // swiftlint:disable force_try
    public var workType: WorkType {
        let jsonEncoder: JSONEncoder = .init()

        switch self {
        case .registerTraveler(let traveler):
            let jsonData = try! jsonEncoder.encode(traveler)
            return .requestData(data: jsonData)
        case .registerHostIndividual(let individual):
            let jsonData = try! jsonEncoder.encode(individual)
            return .requestData(data: jsonData)
        case .registerHostCompany(let company):
            let jsonData = try! jsonEncoder.encode(company)
            return .requestData(data: jsonData)
        }
    }

    public var providerType: AuthProviderType {
        .none
    }

    public var contentType: ContentType? {
        .applicationJson
    }

    public var headers: [String: String]? {
        return ["accept": "*/*"]
    }
}
