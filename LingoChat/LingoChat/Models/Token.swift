// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Security

struct Token {
    let id: UUID
    var jwtString: JWTTokenRepresentable
    var userID: UUID
    
    init(id: UUID, jwtString: JWTTokenRepresentable, userID: UUID) {
        self.id = id
        self.jwtString = jwtString
        self.userID = userID
    }
    
    enum TokenKeys: String, CodingKey {
        case id
        case jwtString = "token"
        case userID
    }
}

//// MARK: JWTDecoder
//extension Token: JWTTokenManager {
//    func encodeJWT(_ jwtToken: JWTTokenRepresentable) throws {
//        throw TokenError.unableToEncode
//    }
//    
//    func decodeJWTString(_ jwtString: String) throws -> JWTTokenRepresentable {
//        do {
//            print("")
////            if let jwtToken = base64UrlDecode(jwtString)
////            return jwtToken
//        } catch {
//            print("decodeJWTString error:", error.localizedDescription)
//            throw TokenError.invalidJWTToken
//        }
//    }
//    
//    func getJWT() throws -> JWTTokenRepresentable {
//        do {
//            print("")
////            let jwtToken = try decodeJWTString(self.jwtString)
////            return jwtToken
//        } catch {
//            throw TokenError.unableToGetJWT
//        }
//    }
//}

//// MARK: - Decodable
//extension Token: Decodable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: TokenKeys.self)
//
//        let tokenString = try container.decode(String.self, forKey: .id)
//        guard let tokenUUID = UUID(uuidString: tokenString) else {
//            throw TokenError.invalidTokenUUID
//        }
//
//        let jwtString = try container.decode(String.self, forKey: .jwtString)
//
//        let userUUIDString = try container.decode(String.self, forKey: .userID)
//        guard let userUUID = UUID(uuidString: userUUIDString) else {
//            throw TokenError.invalidUserUUID
//        }
//
//        self.init(id: tokenUUID, jwtString: jwtString, userID: userUUID)
//
//        // TODO: - save to keychain
//        DispatchQueue(label: "background",
//                      qos: .background).async {}
//    }
//}
//
//// MARK: - Encodable
//extension Token: Encodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: TokenKeys.self)
//
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.jwtString, forKey: .jwtString)
//        try container.encode(self.userID, forKey: .userID)
//    }
//}
