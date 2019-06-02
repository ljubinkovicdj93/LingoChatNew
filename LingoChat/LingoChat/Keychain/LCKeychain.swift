// Project: LingoChat
//
// Created on Saturday, May 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

enum LCKeychainKey: String {
	case token = "com.ljubinkovicd.LingoChat.token"
	case password = "com.ljubinkovicd.LingoChat.password"
}

protocol KeychainRepresentable {
	associatedtype Value: Codable
	associatedtype KeychainKeys: RawRepresentable where KeychainKeys.RawValue == String
	
	func findValue(for key: KeychainKeys) -> Value?
	func saveValue(_ value: Value?, for key: KeychainKeys)
//	func deleteValue(for key: KeychainKeys)
//	func updateValue(_ value: Value?, for key: KeychainKeys)
	
	subscript(key: KeychainKeys) -> Value? { get set }
}

extension KeychainRepresentable {
	subscript(key: KeychainKeys) -> Value? {
		get { return self.findValue(for: key) }
		set {
			DispatchQueue.global().sync(flags: .barrier) {
				self.saveValue(newValue, for: key)
			}
		}
	}
}

class LCKeychain: KeychainRepresentable {
	
	private init() {}
	
	public static let shared = LCKeychain()
	
	func findValue(for key: LCKeychainKey) -> String? {
		let query = keychainQuery(withKey: key)
		query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
		query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
		
		var result: CFTypeRef?
		let status = SecItemCopyMatching(query, &result)
		
		guard
			let resultsDict = result as? NSDictionary,
			let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
			status == noErr
			else {
				debugPrint("Load status: ", status)
				return nil
		}
		return String(data: resultsData, encoding: .utf8)
	}
	
	func saveValue(_ value: String?, for key: LCKeychainKey) {
		let query = keychainQuery(withKey: key)
		let objectData: Data? = value?.data(using: .utf8, allowLossyConversion: false)
		
		if SecItemCopyMatching(query, nil) == noErr {
			if let dictData = objectData {
				let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
				debugPrint("Update status: ", status)
			} else {
				let status = SecItemDelete(query)
				debugPrint("Delete status: ", status)
			}
		} else {
			if let dictData = objectData {
				query.setValue(dictData, forKey: kSecValueData as String)
				let status = SecItemAdd(query, nil)
				debugPrint("Update status: ", status)
			}
		}
	}
	
//	func deleteValue(for key: LCKeychainKey) {
//		let query = keychainQuery(withKey: key)
//	}
//
//	func updateValue(_ value: String?, for key: LCKeychainKey) {
//		<#code#>
//	}
	
	private func keychainQuery(withKey key: LCKeychainKey) -> NSMutableDictionary {
		let result = NSMutableDictionary()
		result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
		result.setValue(key.rawValue, forKey: kSecAttrService as String)
		result.setValue(kSecAttrAccessibleAlwaysThisDeviceOnly, forKey: kSecAttrAccessible as String)
		return result
	}
}
