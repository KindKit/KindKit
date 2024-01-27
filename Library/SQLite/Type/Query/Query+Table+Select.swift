//
//  KindKit
//

import KindString

public extension Query.Table {
    
    struct Select {
        
        let table: String
        var columns: [String] = []
        var `where`: IExpressable? = nil
        var orderBy: [IExpressable] = []
        var limit: IExpressable? = nil
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Query.Table.Select {
    
    func column< Column : ITableColumn >(
        _ column: Column
    ) -> Self {
        var copy = self
        copy.columns = self.columns.kk_appending(column.name)
        return copy
    }
    
    func `where`< Where : ICondition >(
        _ condition: Where
    ) -> Self {
        var copy = self
        copy.where = condition
        return copy
    }
    
    func orderBy< Column : ITableColumn >(
        _ column: Column,
        mode: Query.OrderBy.Mode
    ) -> Self {
        let orderBy = Query.OrderBy(column: column.name, mode: mode)
        var copy = self
        copy.orderBy = self.orderBy.kk_appending(orderBy)
        return copy
    }
    
    func limit(
        _ limit: Count,
        offset: Count? = nil
    ) -> Self {
        var copy = self
        copy.limit = Query.Limit(limit: limit, offset: offset)
        return copy
    }
    
}

extension Query.Table.Select : ISelectQuery {
    
    public var query: String {
        return .kk_build({
            LettersComponent("SELECT ")
            if self.columns.isEmpty == false {
                ForEachComponent(count: self.columns.count, content: { index in
                    LettersComponent(self.columns[index])
                }, separator: {
                    LettersComponent(", ")
                })
            } else {
                LettersComponent("*")
            }
            LettersComponent(" FROM ")
            LettersComponent(self.table)
            if let condition = self.where {
                LettersComponent(" WHERE ")
                LettersComponent(condition.query)
            }
            if self.orderBy.isEmpty == false {
                LettersComponent(" ORDER BY ")
                ForEachComponent(count: self.orderBy.count, content: { index in
                    LettersComponent(self.orderBy[index].query)
                }, separator: {
                    LettersComponent(", ")
                })
            }
            if let limit = self.limit {
                LettersComponent(" ")
                LettersComponent(limit.query)
            }
        })
    }
    
}

public extension IEntity {
    
    func select() -> Query.Table.Select {
        return .init(
            table: self.table.name
        )
    }
    
}
