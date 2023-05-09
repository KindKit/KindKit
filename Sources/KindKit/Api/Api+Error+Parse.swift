//
//  KindKit
//

import Foundation

public extension Api.Error {
        
    struct Parse : Swift.Error, Equatable {
        
        public let statusCode: Int?
        public let response: Data?
        
        public init(
            statusCode: Int? = nil,
            response: Data? = nil
        ) {
            self.statusCode = statusCode
            self.response = response
        }
        
    }
    
}

extension Api.Error.Parse : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "Api.Error.Parse", sequence: { items in
            if let value = self.statusCode {
                items.append(.pair(string: "StatusCode", cast: value))
            }
            if let value = self.response {
                if value.isEmpty == false {
                    items.append(.pair(string: "Response", cast: value))
                }
            }
        })
    }
    
}

extension Api.Error.Parse : CustomStringConvertible {
}

extension Api.Error.Parse : CustomDebugStringConvertible {
}
