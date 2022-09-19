//
//  KindKit
//

import Foundation

public protocol IEnumLocalized : RawRepresentable where RawValue == String {
    
    var bundle: Bundle { get }
    var tables: [String] { get }
    var localized: String { get }
    var `default`: Self? { get }
    
}

public extension IEnumLocalized {
    
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
        let key = self.rawValue
        var result = bundle.localizedString(forKey: key, value: nil, table: nil)
        if result != key {
            return result
        }
        for table in self.tables {
            result = bundle.localizedString(forKey: key, value: nil, table: table)
            if result != key {
                return result
            }
        }
        if let `default` = self.default {
            return `default`.localized
        }
        return key
    }
    
    var contains: Bool {
        let bundle = self.bundle
        let key = self.rawValue
        var result = bundle.localizedString(forKey: key, value: nil, table: nil)
        if result != key {
            return true
        }
        for table in self.tables {
            result = bundle.localizedString(forKey: key, value: nil, table: table)
            if result != key {
                return true
            }
        }
        if let `default` = self.default {
            return `default`.contains
        }
        return false
    }
    
    @inlinable
    func localized(_ args: [String : String]) -> String {
        return self.localized.replace(keys: args)
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
