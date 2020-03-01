//
//  MessageBoardManager.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/12.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum MessageBoardRequest: CAtFERequest {
    case allMessages
    case myCafeComment(Int) // userId
    case createMessage(String, Int, String, [String]) // token, cafeId, content, photos
    case updateMessage(String, Int, String, [String]) // token, msgId, content, photos
    case deleteMessage(String, Int) // token, messageId
    case replyMessage(String, Int, String) // token, messageId, text
    case likeMessages(String) // token
    case addLikeMessage(String, Int) // token, messageId

    var headers: [String: String] {
        switch self {
        case .allMessages:
            return [:]
        case .myCafeComment:
            return [:]
        case .createMessage(let accessToken, _, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .updateMessage(let accessToken, _, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .deleteMessage(let accessToken, _):
            return [HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .replyMessage(let accessToken, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .likeMessages(let accessToken):
            return [HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .addLikeMessage(let accessToken, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
            HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        }
    }

    var body: Data? {
        switch self {
        case .allMessages:
            return nil
        case .myCafeComment:
            return nil
        case .createMessage(_, _, let content, let photos):
            let dict = [
                "comment": content,
                "photos": photos
                ] as [String: Any]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .updateMessage(_, let msgId, let content, let photos):
            let dict = [
                "msgId": msgId,
                "content": content,
                "photos": photos
                ] as [String: Any]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .deleteMessage:
            return nil
        case .replyMessage(_, _, let text):
            let dict = ["text": text]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .likeMessages:
            return nil
        case .addLikeMessage:
            return nil
        }
    }

    var method: String {
        switch self {
        case .allMessages:
            return HTTPMethod.GET.rawValue
        case .myCafeComment:
            return HTTPMethod.GET.rawValue
        case .createMessage:
            return HTTPMethod.PATCH.rawValue
        case .updateMessage:
            return HTTPMethod.PUT.rawValue
        case .deleteMessage:
            return HTTPMethod.DELETE.rawValue
        case .replyMessage:
            return HTTPMethod.POST.rawValue
        case .likeMessages:
            return HTTPMethod.GET.rawValue
        case .addLikeMessage:
            return HTTPMethod.POST.rawValue
        }
    }

    var endPoint: String {
        switch self {
        case .allMessages:
            return "/cafeComments/"
        case .myCafeComment(let userId):
            return "/cafeComments/?user_id=\(userId)"
        case .createMessage(_, let cafeId, _, _):
            return "/cafes/\(cafeId)/comment/"
        case .updateMessage(_, let msgId, _, _):
            return "/cafeComments/\(msgId)/"
        case .deleteMessage(_, let msgId):
            return "/cafeComments/\(msgId)/"
        case .replyMessage(_, let messageId, _):
            return "/cafeComments/\(messageId)/reply/"
        case .likeMessages:
            return "/users/likeComments/"
        case .addLikeMessage(_, let messageId):
            return "/cafeComments/\(messageId)/like/"
        }
    }
}

class MessageBoardManager {
    let decoder = JSONDecoder()
    func getMessageList(completion: @escaping (Result<[CafeComments]>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.allMessages) { (result) in
            switch result {
            case .success(let data):
                do {
                    let messageData = try self.decoder.decode([CafeComments].self, from: data)
                    completion(.success(messageData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getMyCafeComment(userId: Int, completion: @escaping (Result<[CafeComments]>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.myCafeComment(userId)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let myMessage = try self.decoder.decode([CafeComments].self, from: data)
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
                             photos: [String],
                             completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.createMessage(token, cafeID, content, photos)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateMessageInList(token: String,
                             msgId: Int,
                             content: String,
                             photos: [String],
                             completion: @escaping (Result<CafeComments>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.updateMessage(token, msgId, content, photos)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let updateMessage = try self.decoder.decode(CafeComments.self, from: data)
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
                             msgId: Int,
                             completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.deleteMessage(token, msgId)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func replyMessage(token: String,
                      messageId: Int,
                      text: String,
                      completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.replyMessage(token, messageId, text)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getLikeMessages(token: String, completion: @escaping (Result<LikeComments>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.likeMessages(token)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(LikeComments.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addLikeMessage(token: String,
                        messageId: Int,
                        completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.addLikeMessage(token, messageId)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
