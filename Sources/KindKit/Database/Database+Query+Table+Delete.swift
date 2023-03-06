//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Delete {
        
        private let _table: Database.Table
        private let _where: String?
        private let _orderBy: [String]
        private let _limit: String?
        
        init(
            table: Database.Table,
            `where`: String? = nil,
            orderBy: [String] = [],
            limit: String? = nil
        ) {
            self._table = table
            self._where = `where`
            self._orderBy = orderBy
            self._limit = limit
        }
        
    }
    
}

public extension Database.Query.Table.Delete {
        
    func `where`< Where : IDatabaseCondition >(
        _ condition: Where
    ) -> Self {
        return .init(
            table: self._table,
            where: condition.query,
            orderBy: self._orderBy,
            limit: self._limit
        )
    }
    
    func orderBy< Value : IDatabaseValue >(
        _ column: Database.Table.Column< Value >,
        mode: Database.Query.OrderBy.Mode
    ) -> Self {
        let orderBy = Database.Query.OrderBy(column: column.name, mode: mode)
        return .init(
            table: self._table,
            where: self._where,
            orderBy: self._orderBy.kk_appending(orderBy.query),
            limit: self._limit
        )
    }
    
    func limit(
        _ limit: Database.Count,
        offset: Database.Count? = nil
    ) -> Self {
        return .init(
            table: self._table,
            where: self._where,
            orderBy: self._orderBy,
            limit: Database.Query.Limit(limit: limit, offset: offset).query
        )
    }
    
}


extension Database.Query.Table.Delete : IDatabaseUpdateQuery {
    
    public var query: String {
        let builder = StringBuilder("DELETE FROM ")
        builder.append(self._table.name)
        if let condition = self._where {
            builder.append(" WHERE ")
            builder.append(condition)
        }
        if self._orderBy.isEmpty == false {
            builder.append(" ORDER BY ")
            builder.append(self._orderBy, separator: ", ")
        }
        if let limit = self._limit {
            builder.append(" ")
            builder.append(limit)
        }
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func delete() -> Database.Query.Table.Delete {
        return .init(table: self.table)
    }
    
}
