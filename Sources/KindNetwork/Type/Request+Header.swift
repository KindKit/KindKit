//
//  KindKit
//

import Foundation

public extension Request {
    
    struct Header : Hashable {
        
        public let name: String
        public let value: String
        
        public init(
            name: String,
            value: String
        ) {
            self.name = name
            self.value = value
        }
        
    }
    
}

public extension Request.Header {
    
    @inlinable
    static func accept(_ value: String) -> Request.Header {
        return .init(name: "Accept", value: value)
    }
    
    @inlinable
    static func acceptCharset(_ value: String) -> Request.Header {
        return .init(name: "Accept-Charset", value: value)
    }
    
    @inlinable
    static func acceptLanguage(_ value: String) -> Request.Header {
        return .init(name: "Accept-Language", value: value)
    }
    
    @inlinable
    static func acceptEncoding(_ value: String) -> Request.Header {
        return .init(name: "Accept-Encoding", value: value)
    }
    
    @inlinable
    static func authorization(_ value: String) -> Request.Header {
        return .init(name: "Authorization", value: value)
    }
    
    @inlinable
    static func authorization(username: String, password: String) -> Request.Header {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()
        return Self.authorization("Basic \(credential)")
    }
    
    @inlinable
    static func authorization(bearerToken: String) -> Request.Header {
        return Self.authorization("Bearer \(bearerToken)")
    }
    
    @inlinable
    static func contentDisposition(_ value: String) -> Request.Header {
        return .init(name: "Content-Disposition", value: value)
    }
    
    @inlinable
    static func contentType(_ value: String) -> Request.Header {
        return .init(name: "Content-Type", value: value)
    }
    
    @inlinable
    static func contentLength(_ value: Int) -> Request.Header {
        return .init(name: "Content-Length", value: "\(value)")
    }
    
    @inlinable
    static func userAgent(_ value: String) -> Request.Header {
        return .init(name: "User-Agent", value: value)
    }
    
}
