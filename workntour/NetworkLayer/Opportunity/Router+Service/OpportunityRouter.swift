//
//  OpportunityRouter.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 2/7/22.
//

import Foundation
import Networking

enum OpportunityRouter: NetworkTarget {
    case createOpportunity(_ model: OpportunityDto)
    case getOpportunities(id: String)

    public var baseURL: URL {
        Environment.current.apiBaseURL
    }

    public var path: String {
        switch self {
        case .createOpportunity:
            return "/createNewOpportunity"
        case .getOpportunities:
            return "/retrieveAllOpportunityByMemberId"
        }
    }

    public var methodType: MethodType {
        switch self {
        case .createOpportunity:
            return .post
        case .getOpportunities:
            return .get
        }
    }

    // swiftlint:disable force_try
    public var workType: WorkType {
        let jsonEncoder: JSONEncoder = .init()

        switch self {
        case .createOpportunity(let opportunity):
            let jsonData = try! jsonEncoder.encode(opportunity)
            return .requestData(data: jsonData)
        case .getOpportunities:
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
        switch self {
        case .createOpportunity:
            return nil
        case .getOpportunities(let id):
            return ["memberId": id]
        }
    }
}
