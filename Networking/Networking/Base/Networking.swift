//
//  Networking.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation
import Combine

public final class Networking {

    // MARK: Public Variables
    public var preference = Preference.shared

    public let environment: Environment

    // MARK: Object Lifecycle
    public init(environment: Environment = .init()) {
        self.environment = environment
    }
}

// MARK: - NetworkingProtocol
extension Networking: NetworkingProtocol {

    // MARK: - Publishers
    public func request<D, T>(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = .init(),
        scheduler: T,
        class type: D.Type
    ) -> AnyPublisher<D, ProviderError> where D: Decodable, T: Scheduler {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    let error = ProviderError.connectionError(error)
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    throw error
                }
                return urlSession.dataTaskPublisher(for: urlRequest)
            }.receive(on: scheduler)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = ProviderError.invalidServerResponse
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    throw error
                }
                if !httpResponse.isSuccessful {
                    let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                    printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                    throw error
                }
                printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
                return data
            }.decode(type: type.self, decoder: jsonDecoder).mapError { error in
                if let error = error as? ProviderError {
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    return error
                } else {
                    let err = ProviderError.decodingError(error)
                    printDebugDescriptionIfNeeded(urlRequest, err, nil)
                    return err
                }
            }.eraseToAnyPublisher()
    }

    public func request<T: Scheduler>(
        with target: NetworkTarget,
        scheduler: T,
        urlSession: URLSession = .shared
    ) -> AnyPublisher<Response, ProviderError> {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        return urlSession.dataTaskPublisher(for: urlRequest).tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                let error = ProviderError.connectionError(error)
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                throw error
            }
            return urlSession.dataTaskPublisher(for: urlRequest)
        }.receive(on: scheduler)
            .tryMap { (data, response) -> Response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = ProviderError.invalidServerResponse
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    throw error
                }

                guard httpResponse.isSuccessful else {
                    let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                    printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                    throw error
                }
                printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
                return Response(urlResponse: httpResponse, data: data)
            }
            .mapError {
                guard let error = $0 as? ProviderError else {
                    let error = ProviderError.underlying($0)
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    return error
                }
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                return error
            }.eraseToAnyPublisher()
    }

    @discardableResult
    public func request<D, S, T>(
        with target: NetworkTarget,
        class type: D.Type,
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = .init(),
        scheduler: T,
        subscriber: S
    ) -> AnyPublisher<D, ProviderError> where S: Subscriber, T: Scheduler, D: Decodable, S.Input == D, S.Failure == ProviderError {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        let publisher = urlSession.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    let error = ProviderError.connectionError(error)
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    throw error
                }
                return urlSession.dataTaskPublisher(for: urlRequest)
            }.receive(on: scheduler)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = ProviderError.invalidServerResponse
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    throw error
                }
                guard httpResponse.isSuccessful else {
                    let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                    printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                    throw error
                }
                printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
                return data
            }.decode(type: type.self, decoder: jsonDecoder)
            .mapError { error -> ProviderError in
                if let error = error as? ProviderError {
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    return error
                } else {
                    let error = ProviderError.decodingError(error)
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    return error
                }
            }.eraseToAnyPublisher()
        publisher.subscribe(subscriber)
        return publisher
    }

    public func request<S, T>(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        scheduler: T,
        subscriber: S
    ) -> AnyPublisher<Response, ProviderError> where T: Scheduler, S: Subscriber, S.Input == Response, S.Failure == ProviderError {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        let publisher = urlSession.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    let error = ProviderError.connectionError(error)
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    throw error
                }
                return urlSession.dataTaskPublisher(for: urlRequest)
            }
            .receive(on: scheduler)
            .tryMap { data, response -> Response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = ProviderError.invalidServerResponse
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    throw error
                }
                guard httpResponse.isSuccessful else {
                    let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                    printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                    throw error
                }
                printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
                return Response(urlResponse: httpResponse, data: data)
            }
            .mapError { err -> ProviderError in
                guard let error = err as? ProviderError else {
                    let error = ProviderError.underlying(err)

                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    return error

                }
                return error
            }.eraseToAnyPublisher()
        publisher.subscribe(subscriber)
        return publisher
    }

    // MARK: - Completion Block Requests
    @discardableResult
    public func request<D: Decodable>(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = .init(),
        class type: D.Type,
        result: @escaping (Result<D, ProviderError>) -> Void
    ) -> URLSessionTask {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                let error = ProviderError.connectionError(error!)
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                result(.failure(error))
                return
            }
            do {
                guard let data = data else {
                    let error = ProviderError.missingBodyData
                    printDebugDescriptionIfNeeded(urlRequest, error, nil)
                    result(.failure(error))
                    return
                }
                let decoded = try jsonDecoder.decode(type.self, from: data)
                printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
                result(.success(decoded))
            } catch {
                result(.failure(.decodingError(error)))
            }
        }
        task.resume()
        return task
    }

    @discardableResult
    public func request(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        result: @escaping VoidResultCompletion
    ) -> URLSessionTask {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                let error = ProviderError.connectionError(error!)
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                result(.failure(error))
                return
            }
            guard let data = data else {
                let error = ProviderError.missingBodyData
                printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                result(.failure(error))
                return
            }
            printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
            result(.success(Response(urlResponse: httpResponse, data: data)))
        }
        task.resume()
        return task
    }

    @discardableResult
    public func uploadRequest(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        data: Data,
        result: @escaping (Result<(HTTPURLResponse, Data?), ProviderError>) -> Void
    ) -> URLSessionUploadTask {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        let task = urlSession.uploadTask(with: urlRequest, from: data) { data, response, error in
            guard error == nil else {
                let error = ProviderError.underlying(error!)
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                result(.failure(error))
                return
            }
            printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
            result(.success((httpResponse, data)))
        }
        task.resume()
        return task
    }

    @discardableResult
    public func downloadRequest(
        with target: NetworkTarget,
        urlSession: URLSession = URLSession.shared,
        result: @escaping (Result<HTTPURLResponse, ProviderError>) -> Void
    ) -> URLSessionDownloadTask {
        let urlRequest = constructURL(with: target)
        let printDebugDescriptionIfNeeded = environment.printDebugDescriptionIfNeeded
        let task = urlSession.downloadTask(with: urlRequest) { _, response, error in
            guard error == nil else {
                let error = ProviderError.underlying(error!)
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                printDebugDescriptionIfNeeded(urlRequest, error, nil)
                result(.failure(error))
                return
            }
            guard !httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                result(.failure(error))
                return
            }
            printDebugDescriptionIfNeeded(urlRequest, nil, httpResponse.statusCode)
            result(.success(httpResponse))
        }
        task.resume()
        return task
    }

    // MARK: - Async Await

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func request<D: Decodable>(
        with target: NetworkTarget,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .init(),
        class type: D.Type,
        delegate: URLSessionTaskDelegate? = nil
    ) async throws -> D {
        let urlRequest = constructURL(with: target)
        do {
            let (data, urlResponse) = try await urlSession
                .data(
                    for: urlRequest,
                    delegate: delegate
                )
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                environment.printDebugDescriptionIfNeeded(urlRequest, error, nil)
                throw error
            }
            guard httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                environment.printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                throw error
            }
            return try jsonDecoder.decode(type, from: data)
        } catch let error as DecodingError {
            throw ProviderError.decodingError(error)
        } catch let error as URLError {
            throw ProviderError.connectionError(error)
        } catch {
            throw ProviderError.underlying(error)
        }
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func request(
        with target: NetworkTarget,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .init(),
        delegate: URLSessionTaskDelegate? = nil
    ) async throws -> HTTPURLResponse {
        let urlRequest = constructURL(with: target)
        do {
            let (_, urlResponse) = try await urlSession
                .data(
                    for: urlRequest,
                    delegate: delegate
                )
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                environment.printDebugDescriptionIfNeeded(urlRequest, error, nil)
                throw error
            }
            guard httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                environment.printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                throw error
            }
            return httpResponse
        } catch let error as URLError {
            throw ProviderError.connectionError(error)
        } catch {
            throw ProviderError.underlying(error)
        }
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func uploadRequest(
        with target: NetworkTarget,
        urlSession: URLSession = .shared,
        data: Data,
        delegate: URLSessionTaskDelegate? = nil
    ) async throws -> HTTPURLResponse {
        let urlRequest = constructURL(with: target)
        do {
            let (_, urlResponse) = try await urlSession
                .upload(
                    for: urlRequest,
                    from: data,
                    delegate: delegate
                )
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                environment.printDebugDescriptionIfNeeded(urlRequest, error, nil)
                throw error
            }
            guard httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                environment.printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                throw error
            }
            return httpResponse
        } catch let error as URLError {
            throw ProviderError.connectionError(error)
        } catch {
            throw ProviderError.underlying(error)
        }
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func downloadRequest(
        with target: NetworkTarget,
        urlSession: URLSession = .shared,
        delegate: URLSessionTaskDelegate? = nil
    ) async throws -> URL {
        let urlRequest = constructURL(with: target)
        do {
            let (localURL, urlResponse) = try await urlSession
                .download(
                    for: urlRequest,
                    delegate: delegate
                )
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                let error = ProviderError.invalidServerResponse
                environment.printDebugDescriptionIfNeeded(urlRequest, error, nil)
                throw error
            }
            guard httpResponse.isSuccessful else {
                let error = ProviderError.invalidServerResponseWithStatusCode(statusCode: httpResponse.statusCode)
                environment.printDebugDescriptionIfNeeded(urlRequest, error, httpResponse.statusCode)
                throw error
            }
            return localURL
        } catch let error as URLError {
            throw ProviderError.connectionError(error)
        } catch {
            throw ProviderError.underlying(error)
        }
    }
}


// MARK: - Private Extension
private extension Networking {

    func constructURL(with target: NetworkTarget) -> URLRequest {
        NetworkingDebugger.notifyStartExecution()
        switch target.methodType {
        case .get:
            return prepareGetRequest(with: target)

        case .put,
                .patch,
                .post:
            return prepareGeneralRequest(with: target)

        case .delete:
            return prepareDeleteRequest(with: target)
        }
    }

    func prepareGetRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            guard let contentType = target.contentType,
                  contentType == .urlFormEncoded else {
                let url = url.generateUrlWithQuery(with: parameters)
                var request = URLRequest(url: url)
                request.prepareRequest(with: target)
                return request
            }
            var request = URLRequest(url: url)
            request.httpBody = contentType.prepareContentBody(parameters: parameters)
            return request
        default:
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            return request
        }
    }

    func prepareGeneralRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        var request = URLRequest(url: url)
        request.prepareRequest(with: target)
        switch target.workType {
        case .requestParameters(let parameters, _):
            request.httpBody = target.contentType?.prepareContentBody(parameters: parameters)
            return request
        case .requestData(let data):
            request.httpBody = data
            return request
        case .requestWithEncodable(let encodable):
            request.httpBody = try? environment.jsonSerializationData(encodable, .prettyPrinted)
            return request
        case .requestParametersWithBody(let parameters, let data):
            let url = url.generateUrlWithQuery(with: parameters)
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = data
            return request
        default:
            return request
        }
    }

    func prepareDeleteRequest(with target: NetworkTarget) -> URLRequest {
        let url = target.pathAppendedURL
        switch target.workType {
        case .requestParameters(let parameters, _):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = target.contentType?.prepareContentBody(parameters: parameters)
            return request
        case .requestData(let data):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = data
            return request
        case .requestWithEncodable(let encodable):
            var request = URLRequest(url: url)
            request.prepareRequest(with: target)
            request.httpBody = try? environment.jsonSerializationData(encodable, .prettyPrinted)
            return request
        default:
            var request = URLRequest(url: url)
            request.httpMethod = target.methodType.methodName
            return request
        }
    }
}
