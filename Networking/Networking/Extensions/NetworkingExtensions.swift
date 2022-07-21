//
//  NetworkingExtensions.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation

extension HTTPURLResponse {
    var isSuccessful: Bool {
        return (200..<300).contains(statusCode)
    }
}

extension URL {
    func generateUrlWithQuery(with parameters: [String: Any]) -> URL {
        var queryItems: [URLQueryItem] = []
        for parameter in parameters {
            queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value as? String))
        }
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { fatalError("Wrong URL Provided") }
        return url
    }
}

internal extension URLRequest {
    
    private var headerField: String { "Authorization" }
    private var contentTypeHeader: String { "Content-Type" }
    private var acceptHeader: String { "accept" }
    
    mutating func prepareRequest(with target: NetworkTarget) {
        let contentTypeHeaderName = contentTypeHeader
        allHTTPHeaderFields = target.headers
        setValue(target.contentType?.rawValue, forHTTPHeaderField: contentTypeHeaderName)
        setValue(ContentType.applicationJson.rawValue, forHTTPHeaderField: acceptHeader)
        prepareAuthorization(with: target.providerType)
        httpMethod = target.methodType.methodName
    }
    
    private mutating func prepareAuthorization(with authType: AuthProviderType) {
        switch authType {
        case let .basic(username, password):
            let loginString = String(format: "%@:%@", username, password)
            guard let data = loginString.data(using: .utf8) else { return }
            setValue("Basic \(data.base64EncodedString())", forHTTPHeaderField: headerField)
            
        case let .bearer(token):
            setValue("Bearer \(token)", forHTTPHeaderField: headerField)
            
        case .none:
            break
        }
    }
}
