//
//  KindKit
//

import Foundation

public extension Request {
    
    struct Parameter {
        
        public let name: Request.Value
        public let value: Request.Value
        
        public init(
            name: Request.Value,
            value: Request.Value
        ) {
            self.name = name
            self.value = value
        }
        
    }
    
}

extension Request.Parameter : Hashable {
}

extension Request.Parameter : Equatable {
}

extension Request.Parameter : Sendable {
}
