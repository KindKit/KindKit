//
//  KindKitKeychain
//

import Foundation
import Security

public final class Keychain {

    public var accessGroup: String?
    public var synchronizable: Bool

    public init(
        accessGroup: String? = nil,
        synchronizable: Bool = true
    ) {
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }
    
}

public extension Keychain {
    
    enum AccessOptions {
        case whenUnlocked
        case whenUnlockedThisDeviceOnly
        case afterFirstUnlock
        case afterFirstUnlockThisDeviceOnly
        case always
        case whenPasscodeSetThisDeviceOnly
        case alwaysThisDeviceOnly

        public static var defaultOption: AccessOptions {
            return .whenUnlocked
        }

        public var value: String {
            switch self {
            case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked as String
            case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
            case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock as String
            case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String
            case .always: return kSecAttrAccessibleAlways as String
            case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String
            case .alwaysThisDeviceOnly: return kSecAttrAccessibleAlwaysThisDeviceOnly as String
            }
        }
    }
    
}

public extension Keychain {
    
    @discardableResult
    func set(_ value: Data?, key: String, access: AccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(value, key: key, access: access)
    }

    @discardableResult
    func set(_ value: String?, key: String, access: AccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(value, key: key, access: access)
    }

    @discardableResult
    func set(_ value: Bool?, key: String, access: AccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(value, key: key, access: access)
    }
    
    @discardableResult
    func set< Value: BinaryInteger >(_ value: Value?, key: String, access: AccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(String(value), key: key, access: access)
    }

    func get(_ key: String) -> Data? {
        let query = self._process(query: [
            Constants.klass : kSecClassGenericPassword,
            Constants.attrAccount : key,
            Constants.returnData : kCFBooleanTrue as Any,
            Constants.matchLimit : kSecMatchLimitOne
       ], forceSync: false)
        var result: AnyObject? = nil
        let code = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        if code == noErr {
            return result as? Data
        }
        return nil
    }

    func get(_ key: String) -> String? {
        guard let data: Data = self.get(key) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }

    func get(_ key: String) -> Bool? {
        guard let data: Data = self.get(key) else { return nil }
        guard let firstBit = data.first else { return nil }
        return firstBit != 0
    }
    
    func get(_ key: String, radix: Int = 10) -> Int? {
        guard let string: String = self.get(key) else { return nil }
        return Int(string, radix: radix)
    }

    func get(_ key: String, radix: Int = 10) -> UInt? {
        guard let string: String = self.get(key) else { return nil }
        return UInt(string, radix: radix)
    }

    @discardableResult
    func clear() -> Bool {
        let query = self._process(
            query: [
                Constants.klass : kSecClassGenericPassword
            ],
            forceSync: false
        )
        let code = SecItemDelete(query as CFDictionary)
        return code == noErr
    }
    
}

private extension Keychain {

    func _processSet(_ value: Data, key: String, access: AccessOptions) -> Bool {
        self._processDelete(key)
        let query = self._process(
            query: [
                Constants.klass : kSecClassGenericPassword,
                Constants.attrAccount : key,
                Constants.valueData : value,
                Constants.accessible : access.value
            ],
            forceSync: true
        )
        let code = SecItemAdd(query as CFDictionary, nil)
        return code == noErr
    }

    func _processSet(_ value: String, key: String, access: AccessOptions) -> Bool {
        guard let data = value.data(using: String.Encoding.utf8) else { return false }
        return self._processSet(data, key: key, access: access)
    }

    func _processSet(_ value: Bool, key: String, access: AccessOptions) -> Bool {
        let bytes: [UInt8] = (value == true) ? [1] : [0]
        return self._processSet(Data(bytes), key: key, access: access)
    }

    @discardableResult
    func _processDelete(_ key: String) -> Bool {
        let query = self._process(
            query: [
                Constants.klass : kSecClassGenericPassword,
                Constants.attrAccount : key
            ],
            forceSync: false
        )
        let code = SecItemDelete(query as CFDictionary)
        return code == noErr
    }

    func _process(query: [String: Any], forceSync: Bool) -> [String: Any] {
        var result = query
        if let accessGroup = self.accessGroup {
            result[Constants.accessGroup] = accessGroup
        }
        if self.synchronizable == true {
            if forceSync == true {
                result[Constants.attrSynchronizable] = true
            } else {
                result[Constants.attrSynchronizable] = kSecAttrSynchronizableAny
            }
        }
        return result
    }

    struct Constants {

        static var accessGroup: String { return kSecAttrAccessGroup as String }
        static var accessible: String { return kSecAttrAccessible as String }
        static var attrAccount: String { return kSecAttrAccount as String }
        static var attrSynchronizable: String { return kSecAttrSynchronizable as String }
        static var klass: String { return kSecClass as String }
        static var matchLimit: String { return kSecMatchLimit as String }
        static var returnData: String { return kSecReturnData as String }
        static var valueData: String { return kSecValueData as String }

    }

}
