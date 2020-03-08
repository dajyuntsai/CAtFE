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
        let sortResult = data.sorted { (firstItem, secondItem) -> Bool in
            let loveOneAverage1 = firstItem.loveOneAverage ?? 0
            let mealAverage1 = firstItem.mealAverage ?? 0
            let priceAverage1 = firstItem.priceAverage ?? 0
            let surroundingAverage1 = firstItem.surroundingAverage ?? 0
            let trafficAverage1 = firstItem.trafficAverage ?? 0
            let loveOneAverage2 = secondItem.loveOneAverage ?? 0
            let mealAverage2 = secondItem.mealAverage ?? 0
            let priceAverage2 = secondItem.priceAverage ?? 0
            let surroundingAverage2 = secondItem.surroundingAverage ?? 0
            let trafficAverage2 = secondItem.trafficAverage ?? 0
            let sumOfFirstItem = loveOneAverage1 + mealAverage1 + priceAverage1 + surroundingAverage1 + trafficAverage1
            let sumOfSecondItem = loveOneAverage2 + mealAverage2 + priceAverage2 + surroundingAverage2 + trafficAverage2
            return (sumOfFirstItem / 5) > (sumOfSecondItem / 5)
        }
        return sortResult
    }
    
    func sortByMeal(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.mealAverage ?? 0 > $1.mealAverage ?? 0 }
        return sortResult
    }
    
    func sortByPet(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.loveOneAverage ?? 0 > $1.loveOneAverage ?? 0 }
        return sortResult
    }
    
    func sortByPrice(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.priceAverage ?? 0 > $1.priceAverage ?? 0 }
        return sortResult
    }
    
    func sortBySurrounding(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.surroundingAverage ?? 0 > $1.surroundingAverage ?? 0 }
        return sortResult
    }
    
    func sortByTraffic(data: [Cafe]) -> [Cafe] {
        let sortResult = data.sorted { $0.trafficAverage ?? 0 > $1.trafficAverage ?? 0 }
        return sortResult
    }
}
