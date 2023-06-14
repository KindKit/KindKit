//
//  KindKit
//

import Foundation

public extension Database.Table.Column {
    
    final class Alias<
        AliasType : IDatabaseValueAlias
    > : IDatabaseTableColumn {
        
        public typealias DatabaseTypeDeclaration = AliasType.DatabaseTypeDeclaration
        public typealias DatabaseValueCoder = AliasType.DatabaseValueCoder
        
        public let table: IDatabaseTable
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
