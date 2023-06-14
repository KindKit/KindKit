//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Create {
        
        let table: String
        var ifNotExists: Bool = false
        var columns: [IDatabaseExpressable] = []
        var withoutRowId: Bool = false
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Database.Query.Table.Create {
    
    func ifNotExists(
        _ value: Bool = true
    ) -> Self {
        var copy = self
        copy.ifNotExists = value
        return copy
    }
    
    func column< Column : IDatabaseTableColumn >(
        _ column: Column
    ) -> Self {
        let column = Database.Query.Column(column)
        var copy = self
        copy.columns = self.columns.kk_appending(column)
        return copy
    }
    
    func column< Column : IDatabaseTableColumn >(
        _ column: Column,
        on: (Database.Query.Column) -> Database.Query.Column
    ) -> Self {
        let column = on(Database.Query.Column(column))
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

extension Database.Query.Table.Create : IDatabaseQuery {
    
    public var query: String {
        let builder = StringBuilder("CREATE TABLE")
        if self.ifNotExists == true {
            builder.append(" IF NOT EXISTS")
        }
        builder.append(" ")
        builder.append(self.table)
        if self.columns.isEmpty == false {
            builder.append(" (")
            builder.append(self.columns.map({ $0.query }), separator: ", ")
            builder.append(")")
        }
        if self.withoutRowId == true {
            builder.append(" WITHOUT ROWID")
        }
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func create() -> Database.Query.Table.Create {
        return .init(
            table: self.table.name
        )
    }
    
}
