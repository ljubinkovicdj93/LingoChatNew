// Project: LingoChat
//
// Created on Tuesday, April 30, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

final class ChatService {
    static func getAllMessages(for chat: Chat, with completionHandler: @escaping (Result<[Message]>) -> Void) {
        guard let chatId = chat.id?.uuidString else { return }
        var getAllMessagesRequest = NetworkRouter.UserChatRouter.get(params: "34E6E9C0-FF6F-481B-A3E4-30275335446E")
        
        getAllMessagesRequest.route += "/messages"
        
        NetworkRouter.sendRequest(getAllMessagesRequest) { (result: Result<[Message]>) in
            switch result {
            case .success(let messages):
                print("messages", messages)
                completionHandler(.success(messages))
            case .failure(let error):
                print("error", error.localizedDescription)
                completionHandler(.failure(error))
            }
        }
    }
}
