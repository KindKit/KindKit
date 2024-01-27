//
//  KindKit
//

import KindString

public extension Query.Table {
    
    struct Delete {
        
        private let table: String
        private var `where`: IExpressable? = nil
        private var orderBy: [IExpressable] = []
        private var limit: IExpressable? = nil
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Query.Table.Delete {
        
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

extension Query.Table.Delete : IUpdateQuery {
    
    public var query: String {
        return .kk_build({
            LettersComponent("DELETE FROM ")
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
                SpaceComponent()
            }
            if let limit = self.limit {
                LettersComponent(" ")
                LettersComponent(limit.query)
            }
        })
    }
    
}

public extension IEntity {
    
    func delete() -> Query.Table.Delete {
        return .init(table: self.table.name)
    }
    
}
