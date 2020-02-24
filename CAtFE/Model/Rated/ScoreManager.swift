//
//  ScoreManager.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/24.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum ScoreRequest: CAtFERequest {
    case createScore(String, Int, Double, Double, Double, Double, Double) // token, cafeId, love_one, price, surrounding, meal, traffic
    
    var headers: [String: String] {
        switch self {
        case .createScore(let accessToken, _, _, _, _, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .createScore(_, _, let loveOne, let price, let surrounding, let meal, let traffic):
            let dict = [
                "love_one": loveOne,
                "price": price,
                "surrounding": surrounding,
                "meal": meal,
                "traffic": traffic
                ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
    }
    
    var method: String {
        switch self {
        case .createScore:
            return HTTPMethod.POST.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
        case .createScore(_, let cafeId, _, _, _, _, _):
            return "/cafes/\(cafeId)/score/"
        }
    }
}

class ScoreManager {
    let decoder = JSONDecoder()
    func createCafeScore(token: String,
                         cafeId: Int,
                         loveOne: Double,
                         price: Double,
                         surrounding: Double,
                         meal: Double,
                         traffic: Double,
                         completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(ScoreRequest.createScore(token, cafeId, loveOne, price, surrounding, meal, traffic)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
