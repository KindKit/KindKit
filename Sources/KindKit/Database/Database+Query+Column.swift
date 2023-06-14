//
//  KindKit
//

import Foundation

public extension Database.Query {
    
    struct Column {
        
        let columnName: String
        let columnType: String
        var autoIncrement: Bool = false
        
        init(
            columnName: String,
            columnType: String
        ) {
            self.columnName = columnName
            self.columnType = columnType
        }
        
        init< Column : IDatabaseTableColumn >(_ column: Column) {
            self.init(
                columnName: column.name,
                columnType: Column.DatabaseTypeDeclaration.typeDeclaration
            )
        }
        
    }
    
}

public extension Database.Query.Column {
    
    func autoIncrement(_ value: Bool = true) -> Self {
        var copy = self
        copy.autoIncrement = value
        return copy
    }
    
}

extension Database.Query.Column : IDatabaseExpressable {
    
    public var query: String {
        let builder = StringBuilder(self.columnName)
        builder.append(" ")
        builder.append(self.columnType)
        if self.autoIncrement == true {
            builder.append(" AUTOINCREMENT")
        }
        return builder.string
    }
    
}
