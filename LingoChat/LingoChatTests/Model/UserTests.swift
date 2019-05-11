// Project: LingoChat
//
// Created on Sunday, May 05, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import XCTest
@testable import LingoChat
import JWTDecode

class UserTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_Init_WhenGivenEmailAndPassword_SetsEmailAndPassword() {
        let user = User(email: "email@test.com", password: "ABCDEFGh1")
     
        XCTAssertEqual(user.email, "email@test.com")
        XCTAssertEqual(user.password, "ABCDEFGh1")
    }
    
    func test_Init_WhenNotGivenPhotoUrl_SetsUserWithoutPhotoUrl() {
        let user = User(email: "email@test.com",
                        password: "ABCDEFGh1",
                        firstName: "Djordje",
                        lastName: "Ljubinkovic",
                        username: "ljubinkovicdj")
        
        XCTAssertEqual(user.email, "email@test.com")
        XCTAssertEqual(user.password, "ABCDEFGh1")
        XCTAssertEqual(user.firstName, "Djordje")
        XCTAssertEqual(user.lastName, "Ljubinkovic")
        XCTAssertEqual(user.username, "ljubinkovicdj")

        XCTAssertNil(user.photoUrl)
    }
    
    func test_Init_GivenLowerCaseFirstLastName_SetsCapitalizedFirstLastName() {
        let user = User(email: "email@test.com",
                        password: "ABCDEFGh1",
                        firstName: "djordje",
                        lastName: "ljubinkovic",
                        username: "ljubinkovicdj")
        
        XCTAssertEqual(user.firstName, "Djordje")
        XCTAssertEqual(user.lastName, "Ljubinkovic")
    }
    
    func test_FullName_NoFirstLastName_ReturnsNil() {
        let user = User(email: "email@test.com", password: "ABCDEFGh1")
        
        XCTAssertNil(user.fullName)
    }
    
    func test_FullName_WhenGivenFirstLastName_ReturnsFirstLastNameSeparatedByWhitespace() {
        let user = User(email: "email@test.com",
                        password: "ABCDEFGh1",
                        firstName: "djordje",
                        lastName: "ljubinkovic",
                        username: "ljubinkovicdj")
        
        guard let firstName = user.firstName,
            let lastName = user.lastName
            else {
                XCTFail("No first or last name given!")
                return
        }
        
        let fullName = "\(firstName) \(lastName)"
        XCTAssertEqual(user.fullName, fullName)
    }
}

// MARK: - User.Public Tests
extension UserTests {
//    func test_Init() {
//        guard let rawJsonData =
//            #"""
//        {"id":"924A7B82-7BCE-44A0-A791-01085EA71F43","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdE5hbWUiOiJEam9yZGplIiwiaWQiOiI1N0E3MzY1NS0yQjU4LTQ3OTUtQjU5Qi1COEY5N0M5RTlEMTkiLCJsYXN0TmFtZSI6IkxqdWJpbmtvdmljIiwiZW1haWwiOiJ0ZXN0QGdtYWlsLmNvbSIsInVzZXJuYW1lIjoibGp1Ymlua292aWNkaiIsImZyaWVuZENvdW50IjowfQ.CiW_89IYe8OjeLiOuCSfC2Ld-8qyt1-AZC3azJBVH9Q","userID":"57A73655-2B58-4795-B59B-B8F97C9E9D19"}
//        """#
//                .data(using: .utf8)
//            else {
//                XCTFail("Cannot deserialize data from JSON string")
//                return
//        }
//
//        do {
//            let jsonDict = try JSONSerialization.jsonObject(with: rawJsonData, options: []) as? [String: Any]
//
//            let jwt =
//        } catch {
//            XCTFail("Cannot create valid JSON from data: \(error.localizedDescription)")
//            return
//        }
//    }
}
