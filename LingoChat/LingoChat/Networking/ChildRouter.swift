// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Alamofire

// These routes have a child route

protocol HasMessages {}
extension HasMessages where Self: Routable {
    func messageRouter(params: String = "") -> NetworkRouter.MessageRouter {
        var child = NetworkRouter.MessageRouter(params)
        child.route = nestedRouteURL(parent: self, child: child)
        return child
    }
    
    func getMessages(params: String) -> RequestConverterProtocol {
        let returnedMessages = nestedRoute(args: urlParams,
                                           child: NetworkRouter.MessageRouter.get(params: params))
        return returnedMessages
    }
}

protocol HasChats {}
extension HasChats where Self: Routable {
    func chatRouter(params: String = "") -> NetworkRouter.ChatRouter {
        var child = NetworkRouter.ChatRouter(params)
        child.route = nestedRouteURL(parent: self, child: child)
        return child
    }
    
    func getChats() -> RequestConverterProtocol {
        let returnedChats = nestedRoute(args: urlParams,
                                        child: NetworkRouter.ChatRouter.get())
        return returnedChats
    }
    
    func getChat(params: String) -> RequestConverterProtocol {
        let returnedChats = nestedRoute(args: urlParams,
                                        child: NetworkRouter.ChatRouter.get(params: params))
        return returnedChats
    }
}

protocol HasUsers {}
extension HasUsers where Self: Routable {
    func user(params: String) -> NetworkRouter.UserRouter {
        var child = NetworkRouter.UserRouter(params)
        child.route = nestedRouteURL(parent: self, child: child)
        return child
    }
    
    func getUsers() -> RequestConverterProtocol {
        let returnedUsers = nestedRoute(args: urlParams,
                                        child: NetworkRouter.UserRouter.get())
        return returnedUsers
    }
    
    func getUser(params: String) -> RequestConverterProtocol {
        let returnedUser = nestedRoute(args: urlParams,
                                       child: NetworkRouter.UserRouter.get(params: params))
        return returnedUser
    }
    
//    func createUser(parameters: Parameters) -> RequestConverterProtocol {
//        return nestedRoute(args: urlParams, child: NetworkRouter.UserRouter.create(parameters: parameters))
//    }
//
//    func deleteUser(params: String) -> RequestConverterProtocol {
//        return nestedRoute(args: urlParams,
//                           child: NetworkRouter.UserRouter.delete(params: params))
//    }
//
//    func updateUser(params: String, parameters: Parameters) -> RequestConverterProtocol {
//        return nestedRoute(args: urlParams,
//                           child: NetworkRouter.UserRouter.update(params: params,
//                                                                  parameters: parameters))
//    }
}
