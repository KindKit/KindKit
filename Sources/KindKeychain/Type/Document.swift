//
//  KindKit
//

import Foundation
import Security

public final class Document {

    public var accessGroup: String?
    public var synchronizable: Bool

    public init(
        accessGroup: String? = nil,
        synchronizable: Bool = false
    ) {
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }
    
}

public extension Document {
    
    @discardableResult
    func set(_ value: Data, key: String, access: AccessOptions = .defaultOption) -> Bool {
        self._remove(key)
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
    
    func remove(_ key: String) {
        self._remove(key)
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

private extension Document {

    @discardableResult
    func _remove(_ key: String) -> Bool {
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
    
}

private extension Document {

    struct Constants {

        static var accessGroup: String { kSecAttrAccessGroup as String }
        static var accessible: String { kSecAttrAccessible as String }
        static var attrAccount: String { kSecAttrAccount as String }
        static var attrSynchronizable: String { kSecAttrSynchronizable as String }
        static var klass: String { kSecClass as String }
        static var matchLimit: String { kSecMatchLimit as String }
        static var returnData: String { kSecReturnData as String }
        static var valueData: String { kSecValueData as String }

    }

}
