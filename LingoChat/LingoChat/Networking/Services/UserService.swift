// Project: LingoChat
//
// Created on Friday, April 19, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

final class UserService {
    static func getAllUsers() {
        let getAllUsersRequest = NetworkRouter.UserRouter.get()
        NetworkRouter.sendRequest(getAllUsersRequest) { (result: Result<[User.Public]>) in
            switch result {
            case .success(let users):
                print("users:", users)
            case .failure(let error):
                print("error:", error.localizedDescription)
            }
        }
    }
    
    static func getUser(_ id: UUID, with completionHandler: @escaping (Result<User.Public>) -> Void) {
        let getSingleUserRequest = NetworkRouter.UserRouter.get(params: id.uuidString)
        NetworkRouter.sendRequest(getSingleUserRequest) { (result: Result<User.Public>) in
            switch result {
            case .success(let userPublic):
                print("userPublic:", userPublic)
                completionHandler(.success(userPublic))
            case .failure(let error):
                print("error:", error.localizedDescription)
                completionHandler(.failure(error))
            }
        }
    }
    
    static func updateUser(_ id: UUID, userData: User) {
        do {
            let userDictionary = try userData.asDictionary()
            print("userDictionary", userDictionary)
            
            let updateUserRequest = NetworkRouter.UserRouter.update(params: id.uuidString, parameters: userDictionary)
            NetworkRouter.sendRequest(updateUserRequest) { (result: Result<User.Public>) in
                switch result {
                case .success(let updatedUser):
                    print("updatedUser:", updatedUser)
                case .failure(let error):
                    print("error:", error.localizedDescription)
                }
            }
        } catch let error {
            print("error:", error.localizedDescription)
            return
        }
    }
    
    static func getChats(for userId: UUID?, with completionHandler: @escaping (Result<[Chat]>) -> Void) {
        guard let userUUID = userId else { return }
        let getUsersChatsRequest = NetworkRouter.UserRouter(userUUID.uuidString).getChats()
        NetworkRouter.sendRequest(getUsersChatsRequest) { (result: Result<[Chat]>) in
            switch result {
            case .success(let chats):
                print("chats:", chats)
                completionHandler(.success(chats))
            case .failure(let error):
                print("error:", error.localizedDescription)
                completionHandler(.failure(error))
            }
        }
    }
    
    
}
