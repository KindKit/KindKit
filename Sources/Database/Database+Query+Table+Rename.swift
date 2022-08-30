//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query.Table {
    
    struct Rename {
        
        private let _table: Database.Table
        private let _to: Database.Table
        
        init(
            table: Database.Table,
            to: Database.Table
        ) {
            self._table = table
            self._to = to
        }
        
    }
    
}

extension Database.Query.Table.Rename : IDatabaseQuery {
    
    public var query: String {
        let builder = StringBuilder("ALTER TABLE ")
        builder.append(self._table.name)
        builder.append(" RENAME TO ")
        builder.append(self._to.name)
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func rename(to: Database.Table) -> Database.Query.Table.Rename {
        return .init(table: self.table, to: to)
    }
    
}
