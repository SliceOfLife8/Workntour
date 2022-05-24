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
    case registerHostIndividual
    case registerHostCompany

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

    public var workType: WorkType {
        let jsonEncoder = JSONEncoder()

        switch self {
        case .registerTraveler(let model):
            // swiftlint:disable force_try
            let jsonData = try! jsonEncoder.encode(model)
            return .requestData(data: jsonData)
        default:
            return .requestPlain
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
