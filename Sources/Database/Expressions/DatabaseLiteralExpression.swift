//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database {
    
    struct LiteralExpression : IDatabaseExpressable {
        
        public let value: IDatabaseInputValue
        
        public init(_ value: IDatabaseInputValue) {
            self.value = value
        }
        
        public func inputValues() -> [IDatabaseInputValue] {
            return [ self.value ]
        }
        
        public func queryExpression() -> String {
            return "?"
        }
        
    }
    
}
