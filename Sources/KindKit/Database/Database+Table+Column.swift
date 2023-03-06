//
//  KindKit
//

import Foundation

public extension Database.Table {
    
    class Column< Value : IDatabaseValue > {
        
        public unowned let table: Database.Table
        public let name: String
        
        init(
            table: Database.Table,
            name: String
        ) {
            self.table = table
            self.name = name
        }
        
    }
    
}
