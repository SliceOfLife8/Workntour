//
//  ProfileRouter.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
//

import Foundation
import Networking

enum ProfileRouter: NetworkTarget {
    case getTraveler(_ memberId: String)
    case getIndividualHost(_ memberId: String)
    case getCompanyHost(_ memberId: String)
    case updateTraveler(body: TravelerProfile)
    case updateIndividualHost(body: IndividualHostProfile)
    case updateCompanyHost(body: CompanyHostProfile)

    public var baseURL: URL {
        Environment.current.apiBaseURL
    }

    public var path: String {
        switch self {
        case .getTraveler:
            return "/retrieveProfile/traveler"
        case .getIndividualHost:
            return "/retrieveProfile/individualHost"
        case .getCompanyHost:
            return "retrieveProfile/companyHost"
        case .updateTraveler:
            return "/updateProfile/traveler"
        case .updateIndividualHost:
            return "/updateProfile/individualHost"
        case .updateCompanyHost:
            return "/updateProfile/companyHost"
        }
    }

    public var methodType: MethodType {
        switch self {
        case .getTraveler, .getIndividualHost, .getCompanyHost:
            return .get
        case .updateTraveler, .updateIndividualHost, .updateCompanyHost:
            return .put
        }
    }

    // swiftlint:disable force_try
    public var workType: WorkType {
        let jsonEncoder: JSONEncoder = .init()

        switch self {
        case .getTraveler, .getIndividualHost, .getCompanyHost:
            return .requestPlain
        case .updateTraveler(let body):
            let jsonData = try! jsonEncoder.encode(body)
            return .requestData(data: jsonData)
        case .updateIndividualHost(let body):
            let jsonData = try! jsonEncoder.encode(body)
            return .requestData(data: jsonData)
        case .updateCompanyHost(let body):
            let jsonData = try! jsonEncoder.encode(body)
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
        switch self {
        case .getTraveler(let id):
            return [
                "memberId": id
            ]
        case .getIndividualHost(let id):
            return [
                "memberId": id
            ]
        case .getCompanyHost(let id):
            return [
                "memberId": id
            ]
        case .updateTraveler, .updateIndividualHost, .updateCompanyHost:
            return nil
        }
    }

}
