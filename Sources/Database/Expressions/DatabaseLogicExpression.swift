//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database {
    
    struct LogicExpression : IDatabaseExpressable {
        
        public enum Operator {
            case and
            case or
        }
        
        public let `operator`: Operator
        public let expressions: [IDatabaseExpressable]
        
        public init(
            _ `operator`: Operator,
            _ expressions: [IDatabaseExpressable]
        ) {
            self.operator = `operator`
            self.expressions = expressions
        }
        
        public func inputValues() -> [IDatabaseInputValue] {
            var bindables: [IDatabaseInputValue] = []
            self.expressions.forEach({ bindables.append(contentsOf: $0.inputValues()) })
            return bindables
        }
        
        public func queryExpression() -> String {
            let expressions = self.expressions.compactMap({ return "(" + $0.queryExpression() + ")" })
            if expressions.count > 0 {
                return expressions.joined(separator: " " + self.operator.queryString() + " ")
            }
            return ""
        }
        
    }
    
}

extension Database.LogicExpression.Operator {
    
    func queryString() -> String {
        switch self {
        case .and: return "AND"
        case .or: return "OR"
        }
    }
    
}
