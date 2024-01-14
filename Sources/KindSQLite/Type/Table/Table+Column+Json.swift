//
//  KindKit
//

import KindJSON

public extension Table.Column {
    
    final class Json< TypeAlias : ITypeAlias, Coder : KindJSON.IModelCoder > : ITableColumn where Coder.JsonModelDecoded == Coder.JsonModelEncoded {
        
        public typealias SQLiteTypeDeclaration = TypeAlias.SQLiteTypeDeclaration
        public typealias SQLiteValueCoder = ValueCoder.Json< Coder >
        
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
