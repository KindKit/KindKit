//
//  KindKit
//

import KindString

public extension Query.Operator {
    
    struct Default {
        
        let lhs: String
        let `operator`: String
        let rhs: String
        
    }
    
}

extension Query.Operator.Default : ICondition {
    
    public var query: String {
        return .kk_build({
            LettersComponent("(")
            LettersComponent(self.lhs)
            LettersComponent(self.operator)
            LettersComponent(self.rhs)
            LettersComponent(")")
        })
    }
    
}

public extension ICondition {
    
    func add< To : IExpressable >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " + ",
            rhs: to.query
        )
    }

    func sub< To : IExpressable >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " - ",
            rhs: to.query
        )
    }

    func mul< To : IExpressable >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " * ",
            rhs: to.query
        )
    }
    
    func div< To : IExpressable >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " / ",
            rhs: to.query
        )
    }

    func mod< To : IExpressable >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " % ",
            rhs: to.query
        )
    }

}

public extension ITableColumn {
    
    func equal< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " = ",
            rhs: to.query
        )
    }
    
    func equal(_ to: SQLiteValueCoder.SQLiteCoded) throws -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " = ",
            rhs: try SQLiteValueCoder.encode(to).query
        )
    }
    
    func notEqual< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " <> ",
            rhs: to.query
        )
    }
    
    func notEqual(_ to: SQLiteValueCoder.SQLiteCoded) throws -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " <> ",
            rhs: try SQLiteValueCoder.encode(to).query
        )
    }
    
    func less< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " < ",
            rhs: to.query
        )
    }
    
    func less(_ to: SQLiteValueCoder.SQLiteCoded) throws -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " < ",
            rhs: try SQLiteValueCoder.encode(to).query
        )
    }
    
    func lessOrEqual< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " <= ",
            rhs: to.query
        )
    }
    
    func lessOrEqual(_ to: SQLiteValueCoder.SQLiteCoded) throws -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " <= ",
            rhs: try SQLiteValueCoder.encode(to).query
        )
    }
    
    func more< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " > ",
            rhs: to.query
        )
    }
    
    func more(_ to: SQLiteValueCoder.SQLiteCoded) throws -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " > ",
            rhs: try SQLiteValueCoder.encode(to).query
        )
    }
    
    func moreOrEqual< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " >= ",
            rhs: to.query
        )
    }
    
    func moreOrEqual(_ to: SQLiteValueCoder.SQLiteCoded) throws -> Query.Operator.Default {
        return .init(
            lhs: self.name,
            operator: " >= ",
            rhs: try SQLiteValueCoder.encode(to).query
        )
    }

    func `in`(_ to: [SQLiteValueCoder.SQLiteCoded]) throws -> Query.Operator.Default {
        let rhs = try to.map({ try SQLiteValueCoder.encode($0).query }).joined(separator: ", ")
        return .init(
            lhs: self.name,
            operator: " IN ",
            rhs: "(\(rhs))"
        )
    }

    func notIn(_ to: [SQLiteValueCoder.SQLiteCoded]) throws -> Query.Operator.Default {
        let rhs = try to.map({ try SQLiteValueCoder.encode($0).query }).joined(separator: ", ")
        return .init(
            lhs: self.name,
            operator: " NOT IN ",
            rhs: "(\(rhs))"
        )
    }

}


public extension ICondition {
    
    func and< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " AND ",
            rhs: to.query
        )
    }

    func or< To : ICondition >(_ to: To) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " OR ",
            rhs: to.query
        )
    }

    func like(_ value: String) -> Query.Operator.Default {
        return .init(
            lhs: self.query,
            operator: " LIKE ",
            rhs: "'\(value)'"
        )
    }

}
