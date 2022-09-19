//
//  KindKit
//

import Foundation

public extension Database.Query {
    
    struct Column< Value : IDatabaseValue > {
        
        let _column: Database.Table.Column< Value >
        let _autoIncrement: Bool
        
        init(
            column: Database.Table.Column< Value >,
            autoIncrement: Bool = false
        ) {
            self._column = column
            self._autoIncrement = autoIncrement
        }
        
    }
    
}

public extension Database.Query.Column {
    
    func autoIncrement(_ value: Bool = true) -> Self {
        return .init(
            column: self._column,
            autoIncrement: value
        )
    }
    
}

extension Database.Query.Column : IDatabaseExpressable {
    
    public var query: String {
        let builder = StringBuilder(self._column.name)
        builder.append(" ")
        builder.append(Value.TypeDeclaration.typeDeclaration)
        if self._autoIncrement == true {
            builder.append(" AUTOINCREMENT")
        }
        return builder.string
    }
    
}
