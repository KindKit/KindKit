//
//  KindKit
//

import KindString

public extension Query.Table {
    
    struct AddColumn {
        
        let table: String
        let column: IExpressable
        
    }
    
}

extension Query.Table.AddColumn : IQuery {
    
    public var query: String {
        return .kk_build({
            LettersComponent("ALTER TABLE ")
            LettersComponent(self.table)
            LettersComponent(" ADD ")
            LettersComponent(self.column.query)
        })
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
