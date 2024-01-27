//
//  KindKit
//

import Foundation
import KindDebug

public extension Error {
        
    struct Parse : Swift.Error, Hashable, Equatable {
        
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

extension Error.Parse : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .object(name: "Error.Parse", sequence: { items in
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

extension Error.Parse : CustomStringConvertible {
}

extension Error.Parse : CustomDebugStringConvertible {
}
