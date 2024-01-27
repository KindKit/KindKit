//
//  KindKit
//

import KindString

public extension Query.Table {
    
    struct Rename {
        
        let from: String
        let to: String
        
    }
    
}

extension Query.Table.Rename : IQuery {
    
    public var query: String {
        return .kk_build({
            LettersComponent("ALTER TABLE ")
            LettersComponent(self.from)
            LettersComponent(" RENAME TO ")
            LettersComponent(self.to)
        })
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
