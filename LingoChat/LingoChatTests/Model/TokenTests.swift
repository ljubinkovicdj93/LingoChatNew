// Project: LingoChat
//
// Created on Sunday, May 05, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import XCTest
@testable import LingoChat
import JWTHandler

class TokenTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_Init_GivenIdTokenAndUserID_SetsToken() {
        let tokenUUIDString = "b5fda2de-5119-41aa-a6a6-eaabcd8b6a04"

        guard let tokenUUID = UUID(uuidString: tokenUUIDString) else {
            XCTFail("Invalid UUID")
            return
        }

        let jwtTokenString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdE5hbWUiOiJEam9yZGplIiwiaWQiOiI1N0E3MzY1NS0yQjU4LTQ3OTUtQjU5Qi1COEY5N0M5RTlEMTkiLCJsYXN0TmFtZSI6IkxqdWJpbmtvdmljIiwiZW1haWwiOiJ0ZXN0QGdtYWlsLmNvbSIsInVzZXJuYW1lIjoibGp1Ymlua292aWNkaiIsImZyaWVuZENvdW50IjowfQ.CiW_89IYe8OjeLiOuCSfC2Ld-8qyt1-AZC3azJBVH9Q"

        let userUUIDString = "57A73655-2B58-4795-B59B-B8F97C9E9D19"
        guard let userUUID = UUID(uuidString: userUUIDString) else {
            XCTFail("Invalid user UUID")
            return
        }

        let token = Token(id: tokenUUID,
                          jwtString: jwtTokenString,
                          userID: userUUID)

        XCTAssertEqual(token.id, tokenUUID)
        XCTAssertEqual(token.jwtString, jwtTokenString)
        XCTAssertEqual(token.userID, userUUID)
    }

    func test_Init_GivenValidJsonString_SetsToken() {
        let tokenId = #"924A7B82-7BCE-44A0-A791-01085EA71F43"#
        let jwtString = #"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdE5hbWUiOiJEam9yZGplIiwiaWQiOiI1N0E3MzY1NS0yQjU4LTQ3OTUtQjU5Qi1COEY5N0M5RTlEMTkiLCJsYXN0TmFtZSI6IkxqdWJpbmtvdmljIiwiZW1haWwiOiJ0ZXN0QGdtYWlsLmNvbSIsInVzZXJuYW1lIjoibGp1Ymlua292aWNkaiIsImZyaWVuZENvdW50IjowfQ.CiW_89IYe8OjeLiOuCSfC2Ld-8qyt1-AZC3azJBVH9Q"#
        let userId = #"57A73655-2B58-4795-B59B-B8F97C9E9D19"#
        
        let rawJsonString =
            #"""
                {
                "id": "\#(tokenId)",
                "token": "\#(jwtString)",
                "userID": "\#(userId)"
                }
            """#
        
        guard let rawJsonData = rawJsonString.data(using: .utf8) else {
            XCTFail("Cannot deserialize data from JSON string")
            return
        }

        do {
            let tokenStruct = try JSONDecoder().decode(Token.self, from: rawJsonData)

            let tokenUUID = UUID(uuidString: tokenId)
            XCTAssertNotNil(tokenUUID)

            let userUUID = UUID(uuidString: userId)
            XCTAssertNotNil(userUUID)

            XCTAssertEqual(tokenStruct.id, tokenUUID)
            XCTAssertEqual(tokenStruct.userID, userUUID)
            XCTAssertEqual(tokenStruct.jwtString, jwtString)
        } catch {
            XCTFail("Cannot create valid JSON from data: \(error.localizedDescription)")
            return
        }
    }

    func test_DecodeJWTString_ReturnsUser() {
        let validJWTString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdE5hbWUiOiJEam9yZGplIiwiaWQiOiI1N0E3MzY1NS0yQjU4LTQ3OTUtQjU5Qi1COEY5N0M5RTlEMTkiLCJsYXN0TmFtZSI6IkxqdWJpbmtvdmljIiwiZW1haWwiOiJ0ZXN0QGdtYWlsLmNvbSIsInVzZXJuYW1lIjoibGp1Ymlua292aWNkaiIsImZyaWVuZENvdW50IjowfQ.CiW_89IYe8OjeLiOuCSfC2Ld-8qyt1-AZC3azJBVH9Q"
		
		var mockJWTHandler = MockJWTHandler.init()
		
		do {
			try mockJWTHandler.decodeJWT(validJWTString)
			guard let mockToken = mockJWTHandler.jwtToken else { XCTFail("JWTToken shouldn't be nil."); fatalError() }
			
			XCTAssertNotNil(mockToken.body.firstName)
			XCTAssertNotNil(mockToken.body.lastName)
			XCTAssertNotNil(mockToken.body.email)
			XCTAssertNotNil(mockToken.body.username)
			
			XCTAssertEqual(mockToken.body.firstName!, "Djordje")
			XCTAssertEqual(mockToken.body.lastName!, "Ljubinkovic")
			XCTAssertEqual(mockToken.body.email!, "test@gmail.com")
			XCTAssertEqual(mockToken.body.username!, "ljubinkovicdj")
		} catch {
			XCTFail(error.localizedDescription)
		}
    }
}

// MARK: - Mock Classes

extension TokenTests {
	class MockJWTHandler: JWTTokenHandleProtocol {
		typealias Payload = User.Public
		var jwtToken: JWTToken<User.Public>?
	}
}
