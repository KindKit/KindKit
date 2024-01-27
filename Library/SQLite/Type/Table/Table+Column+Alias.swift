//
//  KindKit
//

import Foundation

public extension Table.Column {
    
    final class Alias<
        Alias : IValueAlias
    > : ITableColumn {
        
        public typealias SQLiteTypeDeclaration = Alias.SQLiteTypeDeclaration
        public typealias SQLiteValueCoder = Alias.SQLiteValueCoder
        
        public let table: ITable
        public let name: String
        
        init(
            table: Table,
            name: String
        ) {
            self.table = table
            self.name = name
        }
        
    }
    
}
