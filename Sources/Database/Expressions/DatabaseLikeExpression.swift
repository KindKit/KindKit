//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database {

    struct LikeExpression : IDatabaseExpressable {
        
        public let column: Database.Column
        public let value: String
        
        public init(
            _ column: Database.Column,
            _ value: String
            ) {
            self.column = column
            self.value = value
        }
        
        public func inputValues() -> [IDatabaseInputValue] {
            return []
        }
        
        public func queryExpression() -> String {
            return self.column.name + " LIKE '" + value + "'"
        }
        
    }
    
}
