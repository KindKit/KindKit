//
//  KindKit
//

import KindString

public extension Query.Table {
    
    struct Create {
        
        let table: String
        var ifNotExists: Bool = false
        var columns: [IExpressable] = []
        var withoutRowId: Bool = false
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Query.Table.Create {
    
    func ifNotExists(
        _ value: Bool = true
    ) -> Self {
        var copy = self
        copy.ifNotExists = value
        return copy
    }
    
    func column< Column : ITableColumn >(
        _ column: Column
    ) -> Self {
        let column = Query.Column(column)
        var copy = self
        copy.columns = self.columns.kk_appending(column)
        return copy
    }
    
    func column< Column : ITableColumn >(
        _ column: Column,
        on: (Query.Column) -> Query.Column
    ) -> Self {
        let column = on(Query.Column(column))
        var copy = self
        copy.columns = self.columns.kk_appending(column)
        return copy
    }
    
    func withoutRowId(
        _ value: Bool = true
    ) -> Self {
        var copy = self
        copy.withoutRowId = value
        return copy
    }
    
}

extension Query.Table.Create : IQuery {
    
    public var query: String {
        return .kk_build({
            LettersComponent("CREATE TABLE")
            if self.ifNotExists == true {
                LettersComponent(" IF NOT EXISTS")
            }
            LettersComponent(" ")
            LettersComponent(self.table)
            if self.columns.isEmpty == false {
                LettersComponent(" (")
                ForEachComponent(count: self.columns.count, content: { index in
                    LettersComponent(self.columns[index].query)
                }, separator: {
                    LettersComponent(", ")
                })
                LettersComponent(")")
            }
            if self.withoutRowId == true {
                LettersComponent(" WITHOUT ROWID")
            }
        })
    }
    
}

public extension IEntity {
    
    func create() -> Query.Table.Create {
        return .init(
            table: self.table.name
        )
    }
    
}
