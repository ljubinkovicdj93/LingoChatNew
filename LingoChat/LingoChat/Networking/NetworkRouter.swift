// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Alamofire

/// Protocol that allows us to implement a base URL for our application
protocol URLRouter {
    static var basePathWithHttpProtocol: String { get }
    static var basePathWithWssProtocol: String { get }
}

struct NetworkRouter: URLRouter {
    static var basePathWithHttpProtocol: String {
        #warning("TODO: Move this property to .xcconfig file.")
        return "https://lingo-chat-vapor.herokuapp.com/api"
//        return "http://localhost:8080/api"
    }
    
    static var basePathWithWssProtocol: String {
        #warning("TODO: Move this property to .xcconfig file.")
        return "wss://lingo-chat-vapor.herokuapp.com/api"
//        return "http://localhost:8080/api"
    }
    
    struct UserRouter: Creatable, Readable, Deletable, Updatable, HasChats {
        var route: String = "users"
        var urlParams: String!
    }
    
    struct LoginRouter: Creatable {
        var route: String = "users/login"
        var urlParams: String!
    }
    
    struct RegisterRouter: Creatable {
        #warning("TODO: change to users/register")
        var route: String = "users"
        var urlParams: String!
    }
    
    struct MessageRouter: Creatable, Readable, Deletable, Updatable {
        var route: String = "messages"
        var urlParams: String!
    }

    struct LanguageRouter: Creatable, Readable, Deletable, Updatable {
        var route: String = "languages"
        var urlParams: String!
    }
    
    struct FriendshipRouter: Creatable, Readable, Deletable, Updatable {
        var route: String = "friendships"
        var urlParams: String!
    }
    
    struct ChatRouter: Creatable, Readable, Deletable, Updatable {
        var route: String = "chats"
        var urlParams: String!
    }
    
    struct UserChatRouter: Creatable, Readable, Deletable, Updatable {
        var route: String = "user-chats"
        var urlParams: String!
    }
}

extension NetworkRouter {
    static func sendRequest<Model: Decodable>(_ req: RequestConverterProtocol, with completionHandler: @escaping (Result<Model>) -> Void) {
        Alamofire.request(req).responseJSON { response in
            
            let result = response.handleNetworkResponse(type: Model.self, response)
            
            switch result {
            case .success(let object):
                print(object)
                completionHandler(.success(object))
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(error))
            }
        }
    }
}
