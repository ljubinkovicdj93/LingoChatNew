// Project: LingoChat
//
// Created on Monday, May 06, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Security

extension Optional {
	func or(_ other: Optional) -> Optional {
		switch self {
		case .none: return other
		case .some: return self
		}
	}
	
	func resolve(with error: @autoclosure () -> Error) throws -> Wrapped {
		switch self {
		case .none: throw error()
		case .some(let wrapped): return wrapped
		}
	}
}

public enum JSONValue: Codable {
	case string(String)
	case int(Int)
	case double(Double)
	case bool(Bool)
	case date(Date)
	case object([String: JSONValue])
	case array([JSONValue])
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self = try ((try? container.decode(String.self)).map(JSONValue.string))
			.or((try? container.decode(Int.self)).map(JSONValue.int))
			.or((try? container.decode(Double.self)).map(JSONValue.double))
			.or((try? container.decode(Bool.self)).map(JSONValue.bool))
			.or((try? container.decode(Date.self)).map(JSONValue.date))
			.or((try? container.decode([String: JSONValue].self)).map(JSONValue.object))
			.or((try? container.decode([JSONValue].self)).map(JSONValue.array))
			.resolve(with: DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON")))
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		try container.encode(self)
	}
}

enum JWTTokenError: Error {
    case invalidTokenUUID
    case invalidJWTToken
    case invalidUserUUID
    case invalidBase64Url(String)
    case incorrectNumberOfComponents(Int)
    case unableToGetJWT
    case unableToEncode
}

struct JWTClaim {
	enum JWTClaimKey: String {
		/// iss (issuer): Issuer of the JWT
		case iss
		
		/// sub (subject): Subject of the JWT (the user)
		case sub
		
		/// aud (audience): Recipient for which the JWT is intended
		case aud
		
		/// exp (expiration time): Time after which the JWT expires
		case exp
		
		/// nbf (not before time): Time before which the JWT must not be accepted for processing
		case nbf
		
		 /// iat (issued at time): Time at which the JWT was issued; can be used to determine age of the JWT
		case iat
		
		/// jti (JWT ID): Unique identifier; can be used to prevent the JWT from being replayed (allows a token to be used only once)
		case jti
	}
	
	let issuer: String?
	let subject: String?
	let audience: [String]?
	let expirationTime: Date?
	let notBeforeTime: Date?
	let issuedAtTime: Date?
	let jwtID: String?
	
	init?(json: [String: Any]) {
		guard let issuer = json[JWTClaimKey.iss.rawValue] as? String,
			let subject = json[JWTClaimKey.sub.rawValue] as? String,
			let audience = json[JWTClaimKey.aud.rawValue] as? [String],
			let expirationTime = json[JWTClaimKey.exp.rawValue] as? Date,
			let notBeforeTime = json[JWTClaimKey.nbf.rawValue] as? Date,
			let issuedAtTime = json[JWTClaimKey.iat.rawValue] as? Date,
			let jwtID = json[JWTClaimKey.jti.rawValue] as? String
			
			else {
				return nil
			}
		
		self.issuer = issuer
		self.subject = subject
		self.audience = audience
		self.expirationTime = expirationTime
		self.notBeforeTime = notBeforeTime
		self.issuedAtTime = issuedAtTime
		self.jwtID = jwtID
	}
	
	func expired() -> Bool {
		guard let expiresAt = self.expirationTime else { return true }
		return expiresAt > Date()
	}
}

//protocol JWTClaimRepresentable {
//    /// iss (issuer): Issuer of the JWT
//    var iss: String? { get }
//
//    /// sub (subject): Subject of the JWT (the user)
//    var sub: String? { get }
//
//    /// aud (audience): Recipient for which the JWT is intended
//    var aud: [String]? { get }
//
//    /// exp (expiration time): Time after which the JWT expires
//    var exp: Date? { get }
//
//    /// nbf (not before time): Time before which the JWT must not be accepted for processing
//    var nbf: Date? { get }
//
//    /// iat (issued at time): Time at which the JWT was issued; can be used to determine age of the JWT
//    var iat: Date? { get }
//
//    /// jti (JWT ID): Unique identifier; can be used to prevent the JWT from being replayed (allows a token to be used only once)
//    var jti: String? { get }
//
//    /// computed property which checks if the JWT token has expired.
//    var expired: Bool { get }
//}

protocol JWTTokenRepresentable {
	/// token header part contents
	var header: [String: JSONValue] { get }
	
	/// token body part values or token claims
	var body: [String: JSONValue] { get }
	
	/// token signature part
	var signature: String? { get }
	
	/// jwt string value
	var string: String { get }
}

//extension JWTTokenRepresentable: JWTClaimRepresentable {}

//extension JWTClaimRepresentable where Self: JWTTokenRepresentable {
//    var iss: String? {
//        return body["iss"] as? String
//    }
//
//    var sub: String? {
//        return body["sub"] as? String
//    }
//
//    var aud: [String]? {
//        return body["aud"] as? [String]
//    }
//
//    var exp: Date? {
//        return body["exp"] as? Date
//    }
//
//    var nbf: Date? {
//        return body["nbf"] as? Date
//    }
//
//    var iat: Date? {
//        return body["iat"] as? Date
//    }
//
//    var jti: String? {
//        return body["jti"] as? String
//    }
//
//    var expired: Bool {
//        guard let expiresAt = self.exp else { return true }
//        return expiresAt > Date()
//    }
//}

protocol JWTTokenEncodeDecode: Codable {
    associatedtype JWTTokenObject: JWTTokenRepresentable
    
    var jwtToken: JWTTokenObject { get }
}

struct JWTToken: JWTTokenRepresentable {
	var header: [String: JSONValue]
	var body: [String: JSONValue]
    var signature: String?
    var string: String
}

extension JWTToken: Codable {
	enum JWTTokenKeys: String, CodingKey {
		case header
		case body
		case signature
		case jwtString
	}
	
	// MARK: - Decodable
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: JWTTokenKeys.self)
		
		self.header = try values.decode([String: JSONValue].self, forKey: .header)
		self.body = try values.decode([String: JSONValue].self, forKey: .body)
		self.signature = try values.decode(String.self, forKey: .signature)
		self.string = try values.decode(String.self, forKey: .jwtString)
	}
	
	// MARK: - Encodable
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: JWTTokenKeys.self)
		
		try container.encode(self.header, forKey: .header)
		try container.encode(self.body, forKey: .body)
		try container.encode(self.signature, forKey: .signature)
		try container.encode(self.string, forKey: .jwtString)
	}
}

class JWTTokenManager: JWTTokenEncodeDecode {
	let jwtString: String
    private(set) var jwtToken: JWTToken
	
	init(jwtString: String) throws {
		self.jwtString = jwtString
		
		do {
			self.jwtToken = try unwrapJWT(from: jwtString)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}

fileprivate func unwrapJWT(from jwtString: String) throws -> JWTToken {
	let components = try getJWTComponents(jwtString)
	return JWTToken(header: components.header,
					body: components.payload,
					signature: components.signature,
					string: jwtString)
}

fileprivate func getJWTComponents(_ jwtString: String) throws -> (header: [String: JSONValue], payload: [String: JSONValue], signature: String?) {
	let components = jwtString.components(separatedBy: ".")
	guard components.count == 3 else {
		throw JWTTokenError.incorrectNumberOfComponents(components.count)
	}
	
	guard let header = try decodeJWTPart(components[0]) as? [String: JSONValue] else { fatalError("Can't parse json.") }
	guard let body = try decodeJWTPart(components[1]) as? [String: JSONValue] else { fatalError("Can't parse json.") }
	let signature = components[2]
	
	return (header: header, payload: body, signature: signature)
}

fileprivate func base64UrlDecode(_ value: String) -> Data? {
	var base64 = value
		.replacingOccurrences(of: "-", with: "+")
		.replacingOccurrences(of: "_", with: "/")
	let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
	let requiredLength = 4 * ceil(length / 4.0)
	let paddingLength = requiredLength - length
	if paddingLength > 0 {
		let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
		base64 += padding
	}
	return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
}

fileprivate func decodeJWTPart(_ value: String) throws -> [String: Any] {
	guard let bodyData = base64UrlDecode(value) else {
		throw JWTTokenError.invalidBase64Url(value)
	}
	
	guard let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
		let payload = json as? [String: Any] else {
			throw JWTTokenError.invalidJWTToken
	}
	
	return payload
}
