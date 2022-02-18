//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database {
    
    struct InExpression : IDatabaseExpressable {
        
        public let column: Database.Column
        public let values: [IDatabaseInputValue]
        
        public init(
            _ column: Database.Column,
            _ values: [IDatabaseInputValue]
        ) {
            self.column = column
            self.values = values
        }
        
        public func inputValues() -> [IDatabaseInputValue] {
            return self.values
        }
        
        public func queryExpression() -> String {
            let values = self.values.compactMap({ _ in return "?" })
            return self.column.name + " IN (" +  values.joined(separator: ", ") + ")"
        }
        
    }
    
    struct NotInExpression : IDatabaseExpressable {
        
        public let column: Database.Column
        public let values: [IDatabaseInputValue]
        
        public init(
            _ column: Database.Column,
            _ values: [IDatabaseInputValue]
        ) {
            self.column = column
            self.values = values
        }
        
        public func inputValues() -> [IDatabaseInputValue] {
            return self.values
        }
        
        public func queryExpression() -> String {
            let values = self.values.compactMap({ _ in return "?" })
            return self.column.name + " NOT IN (" +  values.joined(separator: ", ") + ")"
        }
        
    }
    
}
