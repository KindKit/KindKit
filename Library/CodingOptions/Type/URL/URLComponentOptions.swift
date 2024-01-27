//
//  KindKit
//

import Foundation

public struct URLComponentOptions : OptionSet, Sendable {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension URLComponentOptions {
    
    @inlinable
    static var scheme: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var user: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var password: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var host: Self {
        return .init(rawValue: 1 << 3)
    }
    
    @inlinable
    static var port: Self {
        return .init(rawValue: 1 << 4)
    }
    
}

public extension URLComponentOptions {
    
    func validate(url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        if self.contains(.scheme) == true && components.scheme == nil {
            return false
        }
        if self.contains(.user) == true && components.user == nil {
            return false
        }
        if self.contains(.password) == true && components.password == nil {
            return false
        }
        if self.contains(.host) == true && components.host == nil {
            return false
        }
        if self.contains(.port) == true && components.port == nil {
            return false
        }
        return true
    }
    
    func removing(url: URL) -> URL? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        if self.contains(.scheme) == true {
            components.scheme = nil
        }
        if self.contains(.user) == true {
            components.user = nil
        }
        if self.contains(.password) == true {
            components.password = nil
        }
        if self.contains(.host) == true {
            components.host = nil
        }
        if self.contains(.port) == true {
            components.port = nil
        }
        return components.url
    }
    
}
