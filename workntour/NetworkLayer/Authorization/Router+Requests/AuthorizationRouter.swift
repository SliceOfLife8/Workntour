//
//  AuthorizationRouter.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 2/5/22.
//

import Foundation
import Networking

enum AuthorizationRouter: NetworkTarget {
    case registration
    case resendOtp
    case login

    public var baseURL: URL {
        Environment.current.apiBaseURL
    }

    public var path: String {
        switch self {
        case .registration:
            return "/entries"
        case .resendOtp:
            return "/api/resendOtp"
        case .login:
            return "/api/login"
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
        .none
    }

    public var headers: [String: String]? {
        nil
    }
}
