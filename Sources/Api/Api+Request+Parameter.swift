//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    struct Parameter : Hashable {
        
        public let name: Api.Request.Value
        public let value: Api.Request.Value
        
        public init(name: Api.Request.Value, value: Api.Request.Value) {
            self.name = name
            self.value = value
        }
        
    }
    
}
