//
//  HomeRouter.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 14/7/22.
//

import Foundation
import Networking

enum HomeRouter: NetworkTarget {
    case getAllOpportunities(start: String, offset: String, body: OpportunityFilterDto?)
    case filtersNumOfResults(body: OpportunityFilterDto)

    public var baseURL: URL {
        Environment.current.apiBaseURL
    }

    public var path: String {
        switch self {
        case .getAllOpportunities:
            return "/homePage/filters"
        case .filtersNumOfResults:
            return "homePage/filters/numOfResults"
        }
    }

    public var methodType: MethodType {
        switch self {
        case .getAllOpportunities, .filtersNumOfResults:
            return .post
        }
    }

    // swiftlint:disable force_try
    public var workType: WorkType {
        let jsonEncoder: JSONEncoder = .init()

        switch self {
        case .getAllOpportunities(let start, let offset, let body):
            let jsonData = try! jsonEncoder.encode(body)
            let params: [String: Any] = [
                "start": start,
                "offset": offset
            ]

            return .requestParametersWithBody(parameters: params, data: jsonData)
        case .filtersNumOfResults(let filters):
            let jsonData = try! jsonEncoder.encode(filters)

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
        nil
    }
}
