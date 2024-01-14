//
//  KindKit
//

import Foundation

public extension Query.Table {
    
    struct Insert {
        
        let table: String
        var columns: [String] = []
        var values: [IExpressable] = []
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Query.Table.Insert {
    
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
    
}

extension Query.Table.Insert : IInsertQuery {
    
    public var query: String {
        let builder = StringBuilder("INSERT INTO ")
        builder.append(self.table)
        builder.append(" (")
        builder.append(self.columns, separator: ", ")
        builder.append(") VALUES (")
        builder.append(self.values.map({ $0.query }), separator: ", ")
        builder.append(")")
        return builder.string
    }
    
}

public extension IEntity {
    
    func insert() -> Query.Table.Insert {
        return .init(
            table: self.table.name
        )
    }
    
}
