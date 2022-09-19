//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Select {
        
        private let _table: Database.Table
        private let _columns: [String]
        private let _where: String?
        private let _orderBy: [String]
        private let _limit: String?
        
        init(
            table: Database.Table,
            columns: [String] = [],
            `where`: String? = nil,
            orderBy: [String] = [],
            limit: String? = nil
        ) {
            self._table = table
            self._columns = columns
            self._where = `where`
            self._orderBy = orderBy
            self._limit = limit
        }
        
    }
    
}

public extension Database.Query.Table.Select {
    
    func column< Value : IDatabaseValue >(
        _ column: Database.Table.Column< Value >
    ) -> Self {
        return .init(
            table: self._table,
            columns: self._columns.appending(column.name),
            where: self._where,
            orderBy: self._orderBy,
            limit: self._limit
        )
    }
    
    func `where`< Where : IDatabaseCondition >(
        _ condition: Where
    ) -> Self {
        return .init(
            table: self._table,
            columns: self._columns,
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
            columns: self._columns,
            where: self._where,
            orderBy: self._orderBy.appending(orderBy.query),
            limit: self._limit
        )
    }
    
    func limit(
        _ limit: Database.Count,
        offset: Database.Count? = nil
    ) -> Self {
        return .init(
            table: self._table,
            columns: self._columns,
            where: self._where,
            orderBy: self._orderBy,
            limit: Database.Query.Limit(limit: limit, offset: offset).query
        )
    }
    
}

extension Database.Query.Table.Select : IDatabaseSelectQuery {
    
    public var query: String {
        let builder = StringBuilder("SELECT ")
        if self._columns.isEmpty == false {
            builder.append(self._columns, separator: ", ")
        } else {
            builder.append("*")
        }
        builder.append(" FROM ")
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
    
    func select() -> Database.Query.Table.Select {
        return .init(table: self.table)
    }
    
}
