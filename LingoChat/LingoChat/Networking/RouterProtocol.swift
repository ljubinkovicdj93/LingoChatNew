// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Alamofire

protocol Routable {
    typealias Parameters = [String: Any]
    var route: String { get set }
    var urlParams: String! { get set } // for nested routes, ie: /users/:id/chats/:id/etc...
    init()
}

extension Routable {
    /// Create instance of Object that conforms to Routable
    init(_ arg: String = "") {
        self.init()
        urlParams = arg
    }
    
    /// Allows a route to become a nested route
    func nestedRoute(args: String, child: RequestConverterProtocol) -> RequestConverter {
        return RequestConverter(
            method: child.method,
            route: "\(self.route)/\(args)/\(child.route)",
            parameters: child.parameters
        )
    }
    
    /// Generate the URL string for generated nested routes
    func nestedRouteURL(parent: Routable, child: Routable) -> String {
        let nestedRoute = "\(parent.route)/\(parent.urlParams!)/" + child.route
        return nestedRoute
    }
}

// If we have a route that conforms to either Readable, Creatable, Updatable, Deletable,
// we need to declare a route variable and implement an init method.
protocol Creatable: Routable {}
extension Creatable where Self: Routable {
    
    /// Method that allows route to create an object
    ///
    /// - Parameter parameters: Dictionary of objects that will be used to create object
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.User.create(parameters: ["email": "test.user@gmail.com",
    ///                                 "password": "Test1234",
    ///                                 "first_name": "Test",
    ///                                 "last_name": "User"])
    ///````
    static func create(headers: HTTPHeaders = [:], parameters: Parameters = [:]) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)"
        return RequestConverter(method: .post, route: route, headers: headers, parameters: parameters)
    }
}

protocol Readable: Routable {}
extension Readable where Self: Routable {
    /// Method that allows route to return an object
    ///
    /// - Parameter params: Parameters of the object that is being returned
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.User.get(params: "1")
    ///````
    static func get(headers: HTTPHeaders = [:], params: String = "", parameters: Parameters = [:]) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)" + (params.isEmpty ? "" : "/\(params)")
        return RequestConverter(method: .get, route: route, headers: headers, parameters: parameters)
    }
    
    //    static func get(params: Int) -> RequestConverter {
    //        let temp = Self.init()
    //        let route = "\(temp.route)/\(params)"
    //        return RequestConverter(method: .get, route: route)
    //    }
}

protocol Updatable: Routable {}
extension Updatable where Self: Routable {
    /// Method that allows route to update an object
    ///
    /// - Parameter parameters: Dictionary of objects that will be used to create object
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.User.update(params: "1", parameters: ["username": "testUser"])
    ///````
    static func update(headers: HTTPHeaders = [:], params: String, parameters: Parameters) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)/\(params)"
        return RequestConverter(method: .put, route: route, headers: headers, parameters: parameters)
    }
}

protocol Deletable: Routable {}
extension Deletable where Self: Routable {
    /// Method that allows route to delete an object
    ///
    /// - Parameter params: Parameters of the object that is being deleted
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.User.delete(params: "1")
    ///````
    static func delete(headers: HTTPHeaders = [:], params: String, parameters: Parameters = [:]) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)/\(params)"
        return RequestConverter(method: .delete, route: route, headers: headers, parameters: parameters)
    }
}

public protocol RequestConverterProtocol: URLRequestConvertible {
    var method: HTTPMethod { get set }
    var route: String { get set }
    var parameters: Parameters { get set }
    var headers: HTTPHeaders { get set }
}

/// Converter object that will allow us to play nicely with Alamofire
struct RequestConverter: RequestConverterProtocol {
    
    var method: HTTPMethod
    var route: String
    var headers: HTTPHeaders = [:]
    var parameters: Parameters = [:]
    
    /// Create a RequestConverter object
    ///
    /// - Parameters:
    ///   - method: Method to perform on router. Example: `.get`, `.post`, etc.
    ///   - route: Route endpoint on url.
    ///   - parameters: Optional dictionary to pass in objects. Used for `.post` and `.put`
    init(method: HTTPMethod, route: String, headers: HTTPHeaders = [:], parameters: Parameters = [:]) {
        self.method = method
        self.route = route
        self.headers = headers
        self.parameters = parameters
    }
    
    // MARK: - URLRequestConvertible method
    // When we give Alamofire.request() an enum like UserRouter.get(1) then it calls asURLRequest() to get the request to send.
    func asURLRequest() throws -> URLRequest {
        do {
            let url = try NetworkRouter.basePathWithHttpProtocol.asURL()
            var urlRequest = URLRequest(url: url.appendingPathComponent(route))
            urlRequest.httpMethod = self.method.rawValue
            headers.forEach {
                urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
            }
            
            let encoding: ParameterEncoding = self.method == .get ? URLEncoding.default : JSONEncoding(options: .prettyPrinted)
            
            let alamofireRequest = try encoding.encode(urlRequest, with: self.parameters)
            
            return alamofireRequest
        } catch {
            print("asUrlRequestError: \(error.localizedDescription)")
            throw error
        }
    }
}

