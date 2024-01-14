//
//  KindKit
//

import Foundation

public extension Table.Column {
    
    final class Custom<
        TypeDeclaration : ITypeDeclaration,
        ValueCoder : IValueCoder
    > : ITableColumn {
        
        public typealias SQLiteTypeDeclaration = TypeDeclaration
        public typealias SQLiteValueCoder = ValueCoder
        
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
