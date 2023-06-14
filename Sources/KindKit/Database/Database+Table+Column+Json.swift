//
//  KindKit
//

import Foundation

public extension Database.Table.Column {
    
    final class Json< TypeAlias : IDatabaseTypeAlias, Coder : IJsonModelCoder > : IDatabaseTableColumn where Coder.JsonModelDecoded == Coder.JsonModelEncoded {
        
        public typealias DatabaseTypeDeclaration = TypeAlias.DatabaseTypeDeclaration
        public typealias DatabaseValueCoder = Database.ValueCoder.Json< Coder >
        
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
