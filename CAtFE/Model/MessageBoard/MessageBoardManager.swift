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
    case myCafeComment(Int) // userId
    case createMessage(String, Int, String, [String]) // (token, cafeId, content, photos)
    case updateMessage(String, Int, Int, String, [String]) // (token, msgId, cafeId, content, photos)
    case deleteMessage(String, CafeComments, Int)
    case replyMessage(String, Int, String) // (token, messageId, text)

    var headers: [String: String] {
        switch self {
        case .allMessage:
            return [:]
        case .myCafeComment:
            return [:]
        case .createMessage(let accessToken, _, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .updateMessage(let accessToken, _, _, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .deleteMessage(let accessToken, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .replyMessage(let accessToken, _, _):
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue,
                    HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        }
    }

    var body: Data? {
        switch self {
        case .allMessage:
            return nil
        case .myCafeComment:
            return nil
        case .createMessage(_, _, let content, let photos):
            let dict = [
                "comment": content,
                "photos": photos
                ] as [String: Any]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .updateMessage(_, let msgId, let cafeId, let content, let photos):
            let dict = [
                "msgId": msgId,
                "cafeID": cafeId,
                "content": content,
                "photos": photos
                ] as [String: Any]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .deleteMessage:
            return nil
        case .replyMessage(_, _, let text):
            let dict = ["text": text]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
    }

    var method: String {
        switch self {
        case .allMessage:
            return HTTPMethod.GET.rawValue
        case .myCafeComment:
            return HTTPMethod.GET.rawValue
        case .createMessage:
            return HTTPMethod.POST.rawValue
        case .updateMessage:
            return HTTPMethod.PUT.rawValue
        case .deleteMessage:
            return HTTPMethod.DELETE.rawValue
        case .replyMessage:
            return HTTPMethod.POST.rawValue
        }
    }

    var endPoint: String {
        switch self {
        case .allMessage:
            return "/cafeComments/"
        case .myCafeComment(let userId):
            return "/cafeComments/?user_id=\(userId)"
        case .createMessage(_, let cafeId, _, _):
            return "/cafes/\(cafeId)/comment/"
        case .updateMessage(_, let msgId, _, _, _):
            return "/cafes/messageBoard/\(msgId)" // TODO: 還沒改
        case .deleteMessage(_, _, let id):
            return "/cafes/messageBoard/\(id)" // TODO: 還沒改
        case .replyMessage(_, let messageId, _):
            return "/cafeComments/\(messageId)/reply/"
        }
    }
}

class MessageBoardManager {
    let decoder = JSONDecoder()
    func getMessageList(completion: @escaping (Result<[CafeComments]>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.allMessage) { (result) in
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

    func getMyCafeComment(userId: Int, completion: @escaping (Result<CafeCommentModel>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.myCafeComment(userId)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let myMessage = try self.decoder.decode(CafeCommentModel.self, from: data)
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
                             photos: [String], // TODO: [Photos]
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
                             cafeId: Int,
                             content: String,
                             photos: [String],
                             completion: @escaping (Result<CafeComments>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.updateMessage(token, msgId, cafeId, content, photos)) { (result) in
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
                             messageObj: CafeComments,
                             msgId: Int,
                             completion: @escaping (Result<CafeComments>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.deleteMessage(token, messageObj, msgId)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let deleteMessage = try self.decoder.decode(CafeComments.self, from: data)
                    completion(.success(deleteMessage))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func replyMessage(token: String,
                      messageId: Int,
                      text: String,
                      completion: @escaping (Result<CafeComments>) -> Void) {
        HTTPClient.shared.request(MessageBoardRequest.replyMessage(token, messageId, text)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let test = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(test)
                    let replies = try self.decoder.decode(CafeComments.self, from: data)
                    completion(.success((replies)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
