//
//  MessageBoardManager.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/12.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum MessageBoardRequest: CAtFERequest {
    case allMessage
    case myMessage(String)
    case createMessage(String, Int, String, [Photos]) // (token, cafeId, content, photos)
    case updateMessage(String, Int, Int, String, [Photos]) // (token, msgId, cafeId, content, photos)
    case deleteMessage(String, Message, Int)

    var headers: [String: String] {
        switch self {
        case .allMessage:
            return [:]
        case .myMessage(let token):
            return ["X-Auth-Token": "\(token)"]
        case .createMessage(let token, _, _, _):
            return ["Content-Type": "application/json", "X-Auth-Token": "\(token)"]
        case .updateMessage(let token, _, _, _, _):
            return ["Content-Type": "application/json", "X-Auth-Token": "\(token)"]
        case .deleteMessage(let token, _, _):
            return ["Content-Type": "application/json", "X-Auth-Token": "\(token)"]
        }
    }

    var body: Data? {
        switch self {
        case .allMessage:
            return nil
        case .myMessage:
            return nil
        case .createMessage(_, let cafeId, let content, let photos):
            let dict = [
                "cafeID": cafeId,
                "content": content,
                "photos": photos
                ] as [String : Any]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .updateMessage(_, let msgId, let cafeId, let content, let photos):
            let dict = [
                "msgId": msgId,
                "cafeID": cafeId,
                "content": content,
                "photos": photos
                ] as [String : Any]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .deleteMessage:
            return nil
        }
    }

    var method: String {
        switch self {
        case .allMessage:
            return HTTPMethod.GET.rawValue
        case .myMessage:
            return HTTPMethod.GET.rawValue
        case .createMessage:
            return HTTPMethod.POST.rawValue
        case .updateMessage:
            return HTTPMethod.PUT.rawValue
        case .deleteMessage:
            return HTTPMethod.DELETE.rawValue
        }
    }

    var endPoint: String {
        switch self {
        case .allMessage:
            return "/cafes/messageBoard/list"
        case .myMessage:
            return "/cafes/messageBoard"
        case .createMessage:
            return "/cafes/messageBoard"
        case .updateMessage(_, let msgId, _, _, _):
            return "/cafes/messageBoard/\(msgId)"
        case .deleteMessage(_, _, let id):
            return "/cafes/messageBoard/\(id)"
        }
    }
}

class MessageBoardManager {
    let decoder = JSONDecoder()
    func getMessageList(completion: @escaping (Result<MessageModel>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.allMessage) { (result) in
            switch result {
            case .success(let data):
                do {
                    let messageData = try self.decoder.decode(MessageModel.self, from: data)
                    completion(.success(messageData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getMyMessageList(token: String,
                          completion: @escaping (Result<MessageModel>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.myMessage(token)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let myMessage = try self.decoder.decode(MessageModel.self, from: data)
                    completion(.success(myMessage))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createMessageInList(token: String,
                             cafeID: Int,
                             content: String,
                             photos: [Photos],
                             completion: @escaping (Result<MessageModel>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.createMessage(token, cafeID, content, photos)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let messageData = try self.decoder.decode(MessageModel.self, from: data)
                    completion(.success(messageData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateMessageInList(token: String,
                             msgId: Int,
                             cafeId: Int,
                             content: String,
                             photos: [Photos],
                             completion: @escaping (Result<MessageModel>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.updateMessage(token, msgId, cafeId, content, photos)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let updateMessage = try self.decoder.decode(MessageModel.self, from: data)
                    completion(.success(updateMessage))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteMessageInList(token: String,
                             messageObj: Message,
                             msgId: Int,
                             completion: @escaping (Result<MessageModel>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.deleteMessage(token, messageObj, msgId)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let deleteMessage = try self.decoder.decode(MessageModel.self, from: data)
                    completion(.success(deleteMessage))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
