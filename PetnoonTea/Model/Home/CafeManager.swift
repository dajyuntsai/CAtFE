//
//  CafeProvider.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/5.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum CafeRequest: CAtFERequest {
    case cafeList // read
    case updateCafeList // update
    case createCafeList // create
    case deleteCafeList // delete
    
    var headers: [String : String] {
        switch self {
        case .cafeList:
            return [:]
        case .updateCafeList:
            return [:]
        case .createCafeList:
            return [:]
        case .deleteCafeList:
            return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .cafeList:
            return nil
        case .updateCafeList:
            return nil
        case .createCafeList:
            return nil
        case .deleteCafeList:
            return nil
        }
    }
        
    var method: String {
        switch self {
        case .cafeList:
            return HTTPMethod.GET.rawValue
        case .updateCafeList:
            return HTTPMethod.PUT.rawValue
        case .createCafeList:
            return HTTPMethod.POST.rawValue
        case .deleteCafeList:
            return HTTPMethod.DELETE.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
        case .cafeList:
            return "/list?page=1&size=30"
        case .updateCafeList:
            return ""
        case .createCafeList:
            return ""
        case .deleteCafeList:
            return ""
        }
    }
}

class CafeManager {
    let decoder = JSONDecoder()
    // Result<T> 由json最外層的結構決定可不可以包array
    func getCafeList(completion: @escaping (Result<CafeModel>) -> Void) {
        HTTPClient.shared.request(CafeRequest.cafeList) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                do {
                    let cafeData = try strongSelf.decoder.decode(CafeModel.self, from: data)
                    completion(.success(cafeData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
