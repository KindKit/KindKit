//
//  KindKit
//

import Foundation

public extension Query.Table {
    
    struct Drop {
        
        let table: String
        var ifExists: Bool = false
        
        init(
            table: String
        ) {
            self.table = table
        }
        
    }
    
}

public extension Query.Table.Drop {
    
    func ifExists(
        _ value: Bool = true
    ) -> Self {
        var copy = self
        copy.ifExists = value
        return copy
    }
    
}

extension Query.Table.Drop : IQuery {
    
    public var query: String {
        let builder = StringBuilder("DROP TABLE")
        if self.ifExists == true {
            builder.append(" IF EXISTS")
        }
        builder.append(" ")
        builder.append(self.table)
        return builder.string
    }
    
}

public extension IEntity {
    
    func drop() -> Query.Table.Drop {
        return .init(
            table: self.table.name
        )
    }
    
}
