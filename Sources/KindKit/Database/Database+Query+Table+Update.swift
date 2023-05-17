//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Update {
        
        private let _table: Database.Table
        private let _columns: [String]
        private let _values: [String]
        private let _where: String?
        private let _orderBy: [String]
        private let _limit: String?
        
        init(
            table: Database.Table,
            columns: [String] = [],
            values: [String] = [],
            `where`: String? = nil,
            orderBy: [String] = [],
            limit: String? = nil
        ) {
            self._table = table
            self._columns = columns
            self._values = values
            self._where = `where`
            self._orderBy = orderBy
            self._limit = limit
        }
        
    }
    
}

public extension Database.Query.Table.Update {
    
    func set< Value : IDatabaseValue >(
        _ value: Value,
        `in` column: Database.Table.Column< Value >
    ) -> Self {
        var columns = self._columns
        var values = self._values
        if let index = columns.firstIndex(of: column.name) {
            values[index] = value.query
        } else {
            columns.append(column.name)
            values.append(value.query)
        }
        return .init(
            table: self._table,
            columns: columns,
            values: values,
            where: self._where,
            orderBy: self._orderBy,
            limit: self._limit
        )
    }
    
    func set< Encoder : IJsonModelEncoder >(
        _ encoder: Encoder.Type,
        model: Encoder.JsonModelEncoded,
        `in` column: Database.Table.Column< Json >
    ) -> Self {
        let json: Json
        do {
            json = try Json.build({
                try $0.encode(encoder, value: model)
            })
        } catch {
            json = Json(root: NSDictionary())
        }
        return self.set(json, in: column)
    }
    
    func `where`< Where : IDatabaseCondition >(
        _ condition: Where
    ) -> Self {
        return .init(
            table: self._table,
            columns: self._columns,
            values: self._values,
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
            values: self._values,
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
            columns: self._columns,
            values: self._values,
            where: self._where,
            orderBy: self._orderBy,
            limit: Database.Query.Limit(limit: limit, offset: offset).query
        )
    }
    
}

extension Database.Query.Table.Update : IDatabaseUpdateQuery {
    
    public var query: String {
        let builder = StringBuilder("UPDATE ")
        builder.append(self._table.name)
        if self._columns.isEmpty == false {
            builder.append(" SET ")
            builder.append(self._columns.enumerated(), map: { "\($0.element) = \(self._values[$0.offset])" }, separator: ", ")
        }
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
    
    func update() -> Database.Query.Table.Update {
        return .init(table: self.table)
    }
    
}
