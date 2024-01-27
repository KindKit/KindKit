//
//  KindKit
//

import Foundation
import KindDebug

public struct ParseError : Swift.Error, Hashable, Equatable {
    
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

extension ParseError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "NetworkError", sequenceBuilder: {
            if let value = self.statusCode {
                KeyValueInfo(
                    key: StringInfo("StatusCode"),
                    value: value
                )
            }
            if let value = self.response {
                if value.isEmpty == false {
                    KeyValueInfo(
                        key: StringInfo("Response"),
                        value: value
                    )
                }
            }
        })
    }
    
}

extension ParseError : CustomStringConvertible {
}

extension ParseError : CustomDebugStringConvertible {
}
