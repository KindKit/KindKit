//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Rename {
        
        let from: String
        let to: String
        
    }
    
}

extension Database.Query.Table.Rename : IDatabaseQuery {
    
    public var query: String {
        let builder = StringBuilder("ALTER TABLE ")
        builder.append(self.from)
        builder.append(" RENAME TO ")
        builder.append(self.to)
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func rename(to: Database.Table) -> Database.Query.Table.Rename {
        return .init(
            from: self.table.name,
            to: to.name
        )
    }
    
}
