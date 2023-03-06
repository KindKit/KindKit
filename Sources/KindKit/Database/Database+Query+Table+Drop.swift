//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Drop {
        
        private let _table: Database.Table
        private let _ifExists: Bool
        
        init(
            table: Database.Table,
            ifExists: Bool = false
        ) {
            self._table = table
            self._ifExists = ifExists
        }
        
    }
    
}

public extension Database.Query.Table.Drop {
    
    func ifExists(
        _ value: Bool = true
    ) -> Self {
        return .init(
            table: self._table,
            ifExists: value
        )
    }
    
}

extension Database.Query.Table.Drop : IDatabaseQuery {
    
    public var query: String {
        let builder = StringBuilder("DROP TABLE")
        if self._ifExists == true {
            builder.append(" IF EXISTS")
        }
        builder.append(" ")
        builder.append(self._table.name)
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func drop() -> Database.Query.Table.Drop {
        return .init(table: self.table)
    }
    
}
