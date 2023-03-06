//
//  KindKit
//

import Foundation

public extension Database {
    
    class Table {
        
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
        
    }
    
}

public extension Database.Table {
    
    func column< Value : IDatabaseValue >(name: String) -> Database.Table.Column< Value > {
        return .init(table: self, name: name)
    }
    
    func column< Value : IDatabaseValue >(name: String, type: Value.Type) -> Database.Table.Column< Value > {
        return .init(table: self, name: name)
    }
    
}
