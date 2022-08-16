//
//  KindKitApi
//

import Foundation
import KindKitCore

public extension Api.Request {
    
    struct Header : Hashable {
        
        public let name: String
        public let value: String
        
        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
        
    }
    
}

extension Api.Request.Header : CustomStringConvertible {
    
    public var description: String {
        "\(name): \(value)"
    }
    
}

public extension Api.Request.Header {
    
    static func accept(_ value: String) -> Api.Request.Header {
        return .init(name: "Accept", value: value)
    }
    
    static func acceptCharset(_ value: String) -> Api.Request.Header {
        return .init(name: "Accept-Charset", value: value)
    }
    
    static func acceptLanguage(_ value: String) -> Api.Request.Header {
        return .init(name: "Accept-Language", value: value)
    }
    
    static func acceptEncoding(_ value: String) -> Api.Request.Header {
        return .init(name: "Accept-Encoding", value: value)
    }
    
    static func authorization(_ value: String) -> Api.Request.Header {
        return .init(name: "Authorization", value: value)
    }
    
    static func authorization(username: String, password: String) -> Api.Request.Header {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()
        return Self.authorization("Basic \(credential)")
    }
    
    static func authorization(bearerToken: String) -> Api.Request.Header {
        return Self.authorization("Bearer \(bearerToken)")
    }
    
    static func contentDisposition(_ value: String) -> Api.Request.Header {
        return .init(name: "Content-Disposition", value: value)
    }
    
    static func contentType(_ value: String) -> Api.Request.Header {
        return .init(name: "Content-Type", value: value)
    }
    
    static func contentLength(_ value: Int) -> Api.Request.Header {
        return .init(name: "Content-Length", value: "\(value)")
    }
    
    static func userAgent(_ value: String) -> Api.Request.Header {
        return .init(name: "User-Agent", value: value)
    }
    
}
