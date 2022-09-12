//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query.Table {
    
    struct Create {
        
        private let _table: Database.Table
        private let _ifNotExists: Bool
        private let _columns: [String]
        private let _withoutRowId: Bool
        
        init(
            table: Database.Table,
            ifNotExists: Bool = false,
            columns: [String] = [],
            withoutRowId: Bool = false
        ) {
            self._table = table
            self._ifNotExists = ifNotExists
            self._columns = columns
            self._withoutRowId = withoutRowId
        }
        
    }
    
}

public extension Database.Query.Table.Create {
    
    func ifNotExists(
        _ value: Bool = true
    ) -> Self {
        return .init(
            table: self._table,
            ifNotExists: value,
            columns: self._columns,
            withoutRowId: self._withoutRowId
        )
    }
    
    func column< Value : IDatabaseValue >(
        _ column: Database.Table.Column< Value >
    ) -> Self {
        let column = Database.Query.Column(column: column)
        return .init(
            table: self._table,
            ifNotExists: self._ifNotExists,
            columns: self._columns.appending(column.query),
            withoutRowId: self._withoutRowId
        )
    }
    
    func column< Value : IDatabaseValue >(
        _ column: Database.Table.Column< Value >,
        on: (Database.Query.Column< Value >) -> Database.Query.Column< Value >
    ) -> Self {
        let column = on(Database.Query.Column(column: column))
        return .init(
            table: self._table,
            ifNotExists: self._ifNotExists,
            columns: self._columns.appending(column.query),
            withoutRowId: self._withoutRowId
        )
    }
    
    func withoutRowId(
        _ value: Bool = true
    ) -> Self {
        return .init(
            table: self._table,
            ifNotExists: self._ifNotExists,
            columns: self._columns,
            withoutRowId: value
        )
    }
    
}

extension Database.Query.Table.Create : IDatabaseQuery {
    
    public var query: String {
        let builder = StringBuilder("CREATE TABLE")
        if self._ifNotExists == true {
            builder.append(" IF NOT EXISTS")
        }
        builder.append(" ")
        builder.append(self._table.name)
        if self._columns.isEmpty == false {
            builder.append(" (")
            builder.append(self._columns, separator: ", ")
            builder.append(")")
        }
        if self._withoutRowId == true {
            builder.append(" WITHOUT ROWID")
        }
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func create() -> Database.Query.Table.Create {
        return .init(table: self.table)
    }
    
}
