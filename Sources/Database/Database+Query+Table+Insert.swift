//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query.Table {
    
    struct Insert {
        
        private let _table: Database.Table
        private let _columns: [String]
        private let _values: [String]
        
        init(
            table: Database.Table,
            columns: [String] = [],
            values: [String] = []
        ) {
            self._table = table
            self._columns = columns
            self._values = values
        }
        
    }
    
}

public extension Database.Query.Table.Insert {
    
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
            values: values
        )
    }
    
}

extension Database.Query.Table.Insert : IDatabaseInsertQuery {
    
    public var query: String {
        let builder = StringBuilder("INSERT INTO ")
        builder.append(self._table.name)
        builder.append(" (")
        builder.append(self._columns, separator: ", ")
        builder.append(") VALUES (")
        builder.append(self._values, separator: ", ")
        builder.append(")")
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func insert() -> Database.Query.Table.Insert {
        return .init(table: table)
    }
    
}
