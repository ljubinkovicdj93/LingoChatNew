// Project: LingoChat
//
// Created on Sunday, June 02, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import XCTest
@testable import LingoChat

class APIClientTests: XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func test_Register_SavesTokenToKeychain() {
		let user = User(email: "test_user_email4@email.com",
						password: "Abcdefg1!",
						firstName: "Test",
						lastName: "User",
						username: "TestUsername4")
		
		let tokenExpectation = expectation(description: "Token")
		var caughtToken: Token? = nil
		
		RegisterService.register(user: user) { (result) in
			switch result {
			case .success(let token):
				caughtToken = token
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			tokenExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { _ in
			XCTAssertNotNil(caughtToken)
			XCTAssertNotNil(LCKeychain.shared.findValue(for: .token))
			XCTAssertEqual(LCKeychain.shared.findValue(for: .token), caughtToken?.jwtString)
		}
	}
	
	func test_Login_SavesTokenToKeychain() {
		let user = User(email: "test_user_email@email.com",
						password: "Abcdefg1!")
		
		let tokenExpectation = expectation(description: "Token")
		var caughtToken: Token? = nil
		
		LoginService.login(user: user) { (result) in
			switch result {
			case .success(let token):
				caughtToken = token
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			tokenExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { _ in
			XCTAssertNotNil(caughtToken)
			XCTAssertNotNil(LCKeychain.shared.findValue(for: .token))
			XCTAssertEqual(LCKeychain.shared.findValue(for: .token), caughtToken?.jwtString)
		}
	}
}
