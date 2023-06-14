//
//  KindKit
//

import Foundation

public extension Database.Table.Column {
    
    final class Custom<
        TypeDeclaration : IDatabaseTypeDeclaration,
        ValueCoder : IDatabaseValueCoder
    > : IDatabaseTableColumn {
        
        public typealias DatabaseTypeDeclaration = TypeDeclaration
        public typealias DatabaseValueCoder = ValueCoder
        
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
