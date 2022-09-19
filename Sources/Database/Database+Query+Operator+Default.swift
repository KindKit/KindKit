//
//  KindKit
//

import Foundation

public extension Database.Query.Operator {
    
    struct Default {
        
        let lhs: String
        let `operator`: String
        let rhs: String
        
    }
    
}

extension Database.Query.Operator.Default : IDatabaseCondition {
    
    public var query: String {
        let builder = StringBuilder("(")
        builder.append(self.lhs)
        builder.append(self.operator)
        builder.append(self.rhs)
        builder.append(")")
        return builder.string
    }
    
}

public extension IDatabaseCondition {
    
    func add< To : IDatabaseExpressable >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " + ", rhs: to.query)
    }

    func sub< To : IDatabaseExpressable >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " - ", rhs: to.query)
    }

    func mul< To : IDatabaseExpressable >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " * ", rhs: to.query)
    }
    
    func div< To : IDatabaseExpressable >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " / ", rhs: to.query)
    }

    func mod< To : IDatabaseExpressable >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " % ", rhs: to.query)
    }

}

public extension Database.Table.Column {
    
    func equal< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " = ", rhs: to.query)
    }
    
    func equal(_ to: Value) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " = ", rhs: to.query)
    }
    
    func notEqual< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " <> ", rhs: to.query)
    }
    
    func notEqual(_ to: Value) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " <> ", rhs: to.query)
    }
    
    func less< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " < ", rhs: to.query)
    }
    
    func less(_ to: Value) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " < ", rhs: to.query)
    }
    
    func lessOrEqual< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " <= ", rhs: to.query)
    }
    
    func lessOrEqual(_ to: Value) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " <= ", rhs: to.query)
    }
    
    func more< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " > ", rhs: to.query)
    }
    
    func more(_ to: Value) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " > ", rhs: to.query)
    }
    
    func moreOrEqual< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " >= ", rhs: to.query)
    }
    
    func moreOrEqual(_ to: Value) -> Database.Query.Operator.Default {
        return .init(lhs: self.name, operator: " >= ", rhs: to.query)
    }

    func `in`(_ to: [Value]) -> Database.Query.Operator.Default {
        let rhs = to.compactMap({ $0.query }).joined(separator: ", ")
        return .init(lhs: self.name, operator: " IN ", rhs: "(\(rhs))")
    }

    func notIn(_ to: [Value]) -> Database.Query.Operator.Default {
        let rhs = to.compactMap({ $0.query }).joined(separator: ", ")
        return .init(lhs: self.name, operator: " NOT IN ", rhs: "(\(rhs))")
    }

}


public extension IDatabaseCondition {
    
    func and< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " AND ", rhs: to.query)
    }

    func or< To : IDatabaseCondition >(_ to: To) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " OR ", rhs: to.query)
    }

    func like(_ value: String) -> Database.Query.Operator.Default {
        return .init(lhs: self.query, operator: " LIKE ", rhs: value)
    }

}
