// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Alamofire

// These routes have a child route

// MARK: - Authentication Child Routes
//protocol HasAuthentication {}
//extension HasAuthentication where Self: Routable {
//    func loginRoute(params: String) -> NetworkRouter.UserRouter {
//        var child = NetworkRouter.UserRouter(params)
//        child.route = nestedRouteURL(parent: self, child: child)
//        return child
//    }
//    
//    func createStatus(parameters: Parameters) -> RequestConverterProtocol {
//        return nestedRoute(args: urlParams, child: NetworkRouter.SessionsRoute.create(parameters: parameters))
//    }
//    
//    func updateStatus(params: String, parameters: Parameters) -> RequestConverterProtocol {
//        return nestedRoute(args: urlParams, child: NetworkRouter.SessionsRoute.update(params: params, parameters: parameters))
//    }
    
    /*
     func comment(params: String) -> Router.Comment {
     var child = Router.Comment(params)
     child.route = nestedRouteURL(parent: self, child: child)
     return child
     }
     
     func getComment(params: String) -> RequestConverterProtocol {
     let returnComment = nestedRoute(args: urlParams, child: Router.Comment.get(params: params))
     return returnComment
     }
     
     func createComment(parameters: Parameters) -> RequestConverterProtocol {
     return nestedRoute(args: urlParams, child: Router.Comment.create(parameters: parameters))
     }
     
     func deleteComment(params: String) -> RequestConverterProtocol {
     return nestedRoute(args: urlParams, child: Router.Comment.delete(params: params))
     }
     
     func updateComment(params: String, parameters: Parameters) -> RequestConverterProtocol {
     return nestedRoute(args: urlParams, child: Router.Comment.update(params: params, parameters: parameters))
     }
     */
//}
