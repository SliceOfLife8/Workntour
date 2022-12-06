//
//  Data+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 28/11/22.
//

import SwiftyBeaver
import SharedKit

enum AppError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

enum Result<T> {
    case success(T)
    case failure(AppError)
}

enum MediaContext {
    case updateTraveler(body: TravelerUpdatedBody)
    case updateCompanyHost(body: CompanyUpdatedBody)
    case updateIndividualHost(body: IndividualUpdatedBody)

    var path: String {
        switch self {
        case .updateTraveler:
            return "/profile/updateProfile/traveler"
        case .updateCompanyHost:
            return "/profile/updateProfile/companyHost"
        case .updateIndividualHost:
            return "/profile/updateProfile/individualHost"
        }
    }

    func dataRequest<T: Decodable>(objectType: T.Type, completion: @escaping (Result<T>) -> Void) {
        var dataURL = Environment.current.apiBaseURL
        dataURL.appendPathComponent(path)

        // Create the session object
        let session = URLSession.shared

        // now create the URLRequest object using the url object
        var request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let boundary = generateBoundaryString()
        request.httpMethod = "PUT"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String]

        switch self {
        case .updateTraveler(let body):
            let jsonData = try! JSONEncoder().encode(body.updatedTravelerProfile)
            let value = String(decoding: jsonData, as: UTF8.self)
            parameters = ["updatedTravelerProfile": value]

            request.httpBody = createDataBody(
                withParameters: parameters,
                media: body.media,
                boundary: boundary
            )
        case .updateCompanyHost(let body):
            let jsonData = try! JSONEncoder().encode(body.updatedCompanyHostProfile)
            let value = String(decoding: jsonData, as: UTF8.self)
            parameters = ["updatedCompanyHostProfile": value]

            request.httpBody = createDataBody(
                withParameters: parameters,
                media: body.media,
                boundary: boundary
            )
        case .updateIndividualHost(let body):
            let jsonData = try! JSONEncoder().encode(body.updatedIndividualHost)
            let value = String(decoding: jsonData, as: UTF8.self)
            parameters = ["updatedIndividualHost": value]

            request.httpBody = createDataBody(
                withParameters: parameters,
                media: body.media,
                boundary: boundary
            )
        }

        SwiftyBeaver.verbose("CURL:\n \(request.cURL(pretty: true))")

        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(Result.failure(AppError.networkError(error!)))
                return
            }

            guard let data = data,
                  let response = response as? HTTPURLResponse
            else {
                completion(Result.failure(AppError.dataNotFound))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                if 200...299 ~= response.statusCode {
                    completion(Result.success(decodedObject))
                }
                else {
                    completion(Result.failure(AppError.dataNotFound))
                }
            } catch let error {
                debugPrint("statusCode: \(response.statusCode)")
                completion(Result.failure(AppError.jsonParsingError(error as! DecodingError)))
            }
        })

        task.resume()
    }

    func createDataBody(
        withParameters params: [String: String],
        media: Media?,
        boundary: String
    ) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        for (key, value) in params {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition:form-data; name=\"\(key)\"\(lineBreak)")
            body.append("Content-Type: application/json\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }

        if let photo = media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition:form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
            body.append("Content-Type: \"content-type header\"\(lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }

    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
