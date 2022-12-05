//
//  ProfileRouter.swift
//  workntour
//
//  Created by Chris Petimezas on 22/6/22.
//

import Foundation
import Networking

enum ProfileRouter: NetworkTarget {
    case getTraveler(_ memberId: String)
    case getIndividualHost(_ memberId: String)
    case getCompanyHost(_ memberId: String)

    public var baseURL: URL {
        Environment.current.apiBaseURL
    }

    public var path: String {
        switch self {
        case .getTraveler:
            return "/profile/retrieveProfile/traveler"
        case .getIndividualHost:
            return "/profile/retrieveProfile/individualHost"
        case .getCompanyHost:
            return "/profile/retrieveProfile/companyHost"
        }
    }

    public var methodType: MethodType {
        .get
    }

    public var workType: WorkType {
        .requestPlain
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
        }
    }

}
