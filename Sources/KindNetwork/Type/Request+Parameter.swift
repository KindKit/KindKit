//
//  KindKit
//

import Foundation

public extension Request {
    
    struct Parameter : Hashable {
        
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
