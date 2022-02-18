//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database {
    
    struct CompareExpression : IDatabaseExpressable {
        
        public enum Operator {
            case equal
            case notEqual
            case more
            case moreOrEqual
            case less
            case lessOrEqual
        }
        
        public let column: Database.Column
        public let `operator`: Operator
        public let expression: IDatabaseExpressable
        
        public init(
            _ column: Database.Column,
            _ `operator`: Operator,
            _ expression: IDatabaseExpressable
        ) {
            self.column = column
            self.operator = `operator`
            self.expression = expression
        }
        
        public init(
            _ column: Database.Column,
            _ `operator`: Operator,
            _ value: IDatabaseInputValue
        ) {
            self.init(column, `operator`, LiteralExpression(value))
        }
        
        public func inputValues() -> [IDatabaseInputValue] {
            return self.expression.inputValues()
        }
        
        public func queryExpression() -> String {
            return self.column.name + " " + self.operator.queryString() + " " + self.expression.queryExpression()
        }
        
    }

}

extension Database.CompareExpression.Operator {
    
    func queryString() -> String {
        switch self {
        case .equal: return "=="
        case .notEqual: return "<>"
        case .more: return ">"
        case .moreOrEqual: return ">="
        case .less: return "<"
        case .lessOrEqual: return "<="
        }
    }
    
}
