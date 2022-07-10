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
    case getOpportunities(memberId: String)
    case retrieveOpportunity(id: String)
    case deleteOpportunity(id: String)

    public var baseURL: URL {
        Environment.current.apiBaseURL
    }

    public var path: String {
        switch self {
        case .createOpportunity:
            return "/createNewOpportunity"
        case .getOpportunities:
            return "/retrieveAllOpportunityByMemberId"
        case .retrieveOpportunity(let id):
            return "/retrieveOpportunityBy/\(id)"
        case .deleteOpportunity(let id):
            return "/deleteOpportunityBy/\(id)"
        }
    }

    public var methodType: MethodType {
        switch self {
        case .createOpportunity:
            return .post
        case .getOpportunities, .retrieveOpportunity:
            return .get
        case .deleteOpportunity:
            return .delete
        }
    }

    // swiftlint:disable force_try
    public var workType: WorkType {
        let jsonEncoder: JSONEncoder = .init()

        switch self {
        case .createOpportunity(let opportunity):
            let jsonData = try! jsonEncoder.encode(opportunity)
            return .requestData(data: jsonData)
        case .getOpportunities, .retrieveOpportunity, .deleteOpportunity:
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
        case .createOpportunity, .retrieveOpportunity, .deleteOpportunity:
            return nil
        case .getOpportunities(let memberId):
            return ["memberId": memberId]
        }
    }
}
