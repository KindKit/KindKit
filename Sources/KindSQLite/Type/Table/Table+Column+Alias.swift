//
//  KindKit
//

import Foundation

public extension Table.Column {
    
    final class Alias<
        AliasType : IValueAlias
    > : ITableColumn {
        
        public typealias SQLiteTypeDeclaration = AliasType.SQLiteTypeDeclaration
        public typealias SQLiteValueCoder = AliasType.SQLiteValueCoder
        
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
