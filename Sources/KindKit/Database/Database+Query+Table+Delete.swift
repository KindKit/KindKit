//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Delete {
        
        private let table: String
        private var `where`: IDatabaseExpressable? = nil
        private var orderBy: [IDatabaseExpressable] = []
        private var limit: IDatabaseExpressable? = nil
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Database.Query.Table.Delete {
        
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

extension Database.Query.Table.Delete : IDatabaseUpdateQuery {
    
    public var query: String {
        let builder = StringBuilder("DELETE FROM ")
        builder.append(self.table)
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
    
    func delete() -> Database.Query.Table.Delete {
        return .init(table: self.table.name)
    }
    
}
