//
//  HTTPClient.swift
//  CAtFE
//
//   on 2020/1/25.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum HTTPClientError: Error {
    case decodeDataFail
    case clientError(Data)
    case serverError
    case unexpectedError
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case auth = "Authorization"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
}

protocol CAtFERequest {
    var headers: [String: String] { get }
    var body: Data? { get }
    var method: String { get }
    var endPoint: String { get }
}

extension CAtFERequest {
    func makeRequest() -> URLRequest {
        let urlString = Bundle.valueForString(key: CAtFEConstant.urlKey) + endPoint
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.httpMethod = method
        return request
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private init() { }

    func request(
        _ catfeRequest: CAtFERequest, completion: @escaping (Result<Data>) -> Void) {
        URLSession.shared.dataTask( with: catfeRequest.makeRequest(), completionHandler: { (data, response, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
                
            // swiftlint:disable force_cast
            let httpResponse = response as! HTTPURLResponse
            // swiftlint:enable force_cast
            let statusCode = httpResponse.statusCode

            switch statusCode {
            case 200..<300:
                completion(Result.success(data!))
            case 400..<500:
                completion(Result.failure(HTTPClientError.clientError(data!)))
            case 500..<600:
                completion(Result.failure(HTTPClientError.serverError))
            default: return
                completion(Result.failure(HTTPClientError.unexpectedError))
            }
        }).resume()
    }
}
