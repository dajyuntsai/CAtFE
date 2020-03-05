//
//  ScoreManager.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/24.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum ScoreRequest: CAtFERequest {
    case getRatedList
    case createScore(String, Int, Double, Double, Double, Double, Double) // token, cafeId, love_one, price, surrounding, meal, traffic
    
    var headers: [String: String] {
        switch self {
        case .getRatedList:
            return [:]
        case .createScore(let accessToken, _, _, _, _, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .getRatedList:
            return nil
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
        case .getRatedList:
            return HTTPMethod.GET.rawValue
        case .createScore:
            return HTTPMethod.POST.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
        case .getRatedList:
            return "/cafes/"
        case .createScore(_, let cafeId, _, _, _, _, _):
            return "/cafes/\(cafeId)/score/"
        }
    }
}

class ScoreManager {
    let decoder = JSONDecoder()
    func getRatedList(completion: @escaping (Result<CafeModel>) -> Void) {
        HTTPClient.shared.request(ScoreRequest.getRatedList) { (result) in
            switch result {
            case .success(let data):
                do {
                    let ratedList = try self.decoder.decode(CafeModel.self, from: data)
                    completion(.success(ratedList))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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

extension ScoreManager {
    func sortByOverAll(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted {($0.loveOneAverage + $0.mealAverage + $0.priceAverage + $0.surroundingAverage + $0.trafficAverage) / 5 >
            ($1.loveOneAverage + $1.mealAverage + $1.priceAverage + $1.surroundingAverage + $1.trafficAverage) / 5}
        return sortResult
    }
    
    func sortByMeal(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.mealAverage > $1.mealAverage }
        return sortResult
    }
    
    func sortByPet(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.loveOneAverage > $1.loveOneAverage }
        return sortResult
    }
    
    func sortByPrice(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.priceAverage > $1.priceAverage }
        return sortResult
    }
    
    func sortBySurrounding(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.surroundingAverage > $1.surroundingAverage }
        return sortResult
    }
    
    func sortByTraffic(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.trafficAverage > $1.trafficAverage }
        return sortResult
    }
}
