//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct AddColumn {
        
        let table: String
        let column: IDatabaseExpressable
        
    }
    
}

extension Database.Query.Table.AddColumn : IDatabaseQuery {
    
    public var query: String {
        let builder = StringBuilder("ALTER TABLE ")
        builder.append(self.table)
        builder.append(" ADD ")
        builder.append(self.column.query)
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func add<
        Column : IDatabaseTableColumn
    >(
        column: Column
    ) -> Database.Query.Table.AddColumn {
        return .init(
            table: self.table.name,
            column: Database.Query.Column(column)
        )
    }
    
}
