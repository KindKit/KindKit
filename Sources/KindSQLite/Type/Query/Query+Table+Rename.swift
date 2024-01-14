//
//  KindKit
//

import Foundation

public extension Query.Table {
    
    struct Rename {
        
        let from: String
        let to: String
        
    }
    
}

extension Query.Table.Rename : IQuery {
    
    public var query: String {
        let builder = StringBuilder("ALTER TABLE ")
        builder.append(self.from)
        builder.append(" RENAME TO ")
        builder.append(self.to)
        return builder.string
    }
    
}

public extension IEntity {
    
    func rename(to: Table) -> Query.Table.Rename {
        return .init(
            from: self.table.name,
            to: to.name
        )
    }
    
}
