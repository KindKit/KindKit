//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Update {
        
        let table: String
        var columns: [String] = []
        var values: [IDatabaseExpressable] = []
        var `where`: IDatabaseExpressable? = nil
        var orderBy: [IDatabaseExpressable] = []
        var limit: IDatabaseExpressable? = nil
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Database.Query.Table.Update {
    
    func set< Column : IDatabaseTableColumn >(
        _ value: Column.DatabaseValueCoder.DatabaseCoded,
        `in` column: Column
    ) throws -> Self {
        var columns = self.columns
        var values = self.values
        let value = try Column.DatabaseValueCoder.encode(value)
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
    
    func `where`< Where : IDatabaseCondition >(
        _ condition: Where
    ) -> Self {
        var copy = self
        copy.where = condition
        return copy
    }
    
    func orderBy< Column : IDatabaseTableColumn >(
        _ column: Column,
        mode: Database.Query.OrderBy.Mode
    ) -> Self {
        let orderBy = Database.Query.OrderBy(column: column.name, mode: mode)
        var copy = self
        copy.orderBy = self.orderBy.kk_appending(orderBy)
        return copy
    }
    
    func limit(
        _ limit: Database.Count,
        offset: Database.Count? = nil
    ) -> Self {
        var copy = self
        copy.limit = Database.Query.Limit(limit: limit, offset: offset)
        return copy
    }
    
}

extension Database.Query.Table.Update : IDatabaseUpdateQuery {
    
    public var query: String {
        let builder = StringBuilder("UPDATE ")
        builder.append(self.table)
        if self.columns.isEmpty == false {
            builder.append(" SET ")
            builder.append(self.columns.enumerated(), map: { "\($0.element) = \(self.values[$0.offset].query)" }, separator: ", ")
        }
        if let condition = self.where {
            builder.append(" WHERE ")
            builder.append(condition.query)
        }
        if self.orderBy.isEmpty == false {
            builder.append(" ORDER BY ")
            builder.append(self.orderBy.map({ $0.query }), separator: ", ")
        }
        if let limit = self.limit {
            builder.append(" ")
            builder.append(limit.query)
        }
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func update() -> Database.Query.Table.Update {
        return .init(
            table: self.table.name
        )
    }
    
}
