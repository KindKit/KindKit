//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct AddColumn {
        
        private let _table: Database.Table
        private let _column: String
        
        init(
            table: Database.Table,
            column: String
        ) {
            self._table = table
            self._column = column
        }
        
    }
    
}

extension Database.Query.Table.AddColumn : IDatabaseQuery {
    
    public var query: String {
        let builder = StringBuilder("ALTER TABLE ")
        builder.append(self._table.name)
        builder.append(" ADD ")
        builder.append(self._column)
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func add< Value : IDatabaseValue >(column: Database.Table.Column< Value >) -> Database.Query.Table.AddColumn {
        return .init(table: self.table, column: Database.Query.Column(column: column).query)
    }
    
}
