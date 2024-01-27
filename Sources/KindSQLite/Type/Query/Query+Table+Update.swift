//
//  KindKit
//

import KindString

public extension Query.Table {
    
    struct Update {
        
        let table: String
        var columns: [String] = []
        var values: [IExpressable] = []
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

public extension Query.Table.Update {
    
    func set< Column : ITableColumn >(
        _ value: Column.SQLiteValueCoder.SQLiteCoded,
        `in` column: Column
    ) throws -> Self {
        var columns = self.columns
        var values = self.values
        let value = try Column.SQLiteValueCoder.encode(value)
        if let index = columns.firstIndex(of: column.name) {
            values[index] = value
        } else {
            columns.append(column.name)
            values.append(value)
        }
        var copy = self
        copy.columns = columns
        copy.values = values
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

extension Query.Table.Update : IUpdateQuery {
    
    public var query: String {
        return .kk_build({
            LettersComponent("UPDATE ")
            LettersComponent(self.table)
            if self.columns.isEmpty == false {
                LettersComponent(" SET ")
                ForEachComponent(count: self.columns.count, content: { index in
                    LettersComponent(self.columns[index])
                    LettersComponent(" = ")
                    LettersComponent(self.values[index].query)
                }, separator: {
                    LettersComponent(", ")
                })
            }
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
    
    func update() -> Query.Table.Update {
        return .init(
            table: self.table.name
        )
    }
    
}
