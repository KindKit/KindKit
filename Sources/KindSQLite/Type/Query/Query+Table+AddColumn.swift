//
//  KindKit
//

import Foundation

public extension Query.Table {
    
    struct AddColumn {
        
        let table: String
        let column: IExpressable
        
    }
    
}

extension Query.Table.AddColumn : IQuery {
    
    public var query: String {
        let builder = StringBuilder("ALTER TABLE ")
        builder.append(self.table)
        builder.append(" ADD ")
        builder.append(self.column.query)
        return builder.string
    }
    
}

public extension IEntity {
    
    func add<
        Column : ITableColumn
    >(
        column: Column
    ) -> Query.Table.AddColumn {
        return .init(
            table: self.table.name,
            column: Query.Column(column)
        )
    }
    
}
