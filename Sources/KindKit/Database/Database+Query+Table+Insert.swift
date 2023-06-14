//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Insert {
        
        let table: String
        var columns: [String] = []
        var values: [IDatabaseExpressable] = []
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Database.Query.Table.Insert {
    
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
    
}

extension Database.Query.Table.Insert : IDatabaseInsertQuery {
    
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

public extension IDatabaseEntity {
    
    func insert() -> Database.Query.Table.Insert {
        return .init(
            table: self.table.name
        )
    }
    
}
