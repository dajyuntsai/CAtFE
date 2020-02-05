//
//  CafeProvider.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/5.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation
// TODO: 補寫PUT & POST 擋店家名稱重複的邏輯
enum CafeRequest: CAtFERequest {
    case cafeList // read
    case updateCafeList(Int, Cafe) // update
    case createCafeList(Cafe) // create
    case deleteCafeList(Int, Cafe) // delete
    
    var headers: [String : String] {
        switch self {
        case .cafeList:
            return [:]
        case .updateCafeList:
            return ["Content-Type":"application/json"]
        case .createCafeList:
            return ["Content-Type":"application/json"]
        case .deleteCafeList:
            return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .cafeList:
            return nil
        case .updateCafeList( _, let cafe):
            do {
              let encode = try JSONEncoder().encode(cafe)
                return encode
            } catch {
                print(error)
            }
            return nil
        case .createCafeList(let cafe):
            do {
              let encode = try JSONEncoder().encode(cafe)
                return encode
            } catch {
                print(error)
            }
            return nil
        case .deleteCafeList( _, _):
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
            return "/cafes/list?page=1&size=30"
        case .updateCafeList(let id, _):
            return "/cafes/\(id)"
        case .createCafeList:
            return "/cafes"
        case .deleteCafeList(let id, _):
            return "/cafes/\(id)"
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
    
    func updateCafeInList(cafeId: Int, cafeObj: Cafe, completion: @escaping (Result<CafeModel>) -> Void) {
        HTTPClient.shared.request(CafeRequest.updateCafeList(cafeId, cafeObj)) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let test = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(test)
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createCafeInList(cafeObj: Cafe, completion: @escaping (Result<CafeModel>) -> Void) {
        HTTPClient.shared.request(CafeRequest.createCafeList(cafeObj)) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let test = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(test)
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteCafeInList(cafeId: Int, cafeObj: Cafe, completion: @escaping (Result<CafeModel>) -> Void) {
        HTTPClient.shared.request(CafeRequest.deleteCafeList(cafeId, cafeObj)) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let test = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(test)
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
