//
//  KindKit
//

import Foundation

public protocol ILocalized {
    
    var key: String { get }
    var localized: String { get }
    
    var bundle: Bundle { get }
    var tables: [String] { get }
    var `default`: Self? { get }
    
}

public extension ILocalized where Self : RawRepresentable, RawValue == String {
    
    var key: String {
        return self.rawValue
    }
    
}

public extension ILocalized {
    
    var bundle: Bundle {
        return Bundle.main
    }
    
    var tables: [String] {
        return []
    }
    
    var `default`: Self? {
        return nil
    }
    
    var localized: String {
        let bundle = self.bundle
        let key = self.key
        var result: String
        for table in self.tables {
            result = bundle.localizedString(forKey: key, value: nil, table: table)
            if result != key {
                return result
            }
        }
        result = bundle.localizedString(forKey: key, value: nil, table: nil)
        if result != key {
            return result
        }
        if let `default` = self.default {
            return `default`.localized
        }
        return key
    }
    
    var contains: Bool {
        let bundle = self.bundle
        let key = self.key
        var result: String
        for table in self.tables {
            result = bundle.localizedString(forKey: key, value: nil, table: table)
            if result != key {
                return true
            }
        }
        result = bundle.localizedString(forKey: key, value: nil, table: nil)
        if result != key {
            return true
        }
        if let `default` = self.default {
            return `default`.contains
        }
        return false
    }
    
    @inlinable
    func replace(_ args: [String : String]) -> String {
        return self.localized.kk_replace(keys: args)
    }
    
    @inlinable
    func format(_ arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    @inlinable
    func format(arguments: [CVarArg]) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
}
