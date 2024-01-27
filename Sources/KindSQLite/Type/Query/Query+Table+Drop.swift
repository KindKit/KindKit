//
//  KindKit
//

import KindString

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
        return .kk_build({
            LettersComponent("DROP TABLE")
            if self.ifExists == true {
                LettersComponent(" IF EXISTS")
            }
            LettersComponent(" ")
            LettersComponent(self.table)
        })
    }
    
}

public extension IEntity {
    
    func drop() -> Query.Table.Drop {
        return .init(
            table: self.table.name
        )
    }
    
}
