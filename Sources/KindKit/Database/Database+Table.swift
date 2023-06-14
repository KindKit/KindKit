//
//  KindKit
//

import Foundation

public extension Database {
    
    final class Table : IDatabaseTable {
        
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
        
    }
    
}

public extension Database.Table {
    
    func column<
        Alias : IDatabaseValueAlias
    >(
        name: String
    ) -> Database.Table.Column.Alias< Alias > {
        return .init(table: self, name: name)
    }
    
    func column<
        TypeDeclaration : IDatabaseTypeDeclaration,
        ValueCoder : IDatabaseValueCoder
    >(
        name: String
    ) -> Database.Table.Column.Custom< TypeDeclaration, ValueCoder > {
        return .init(table: self, name: name)
    }
    
    func column<
        TypeAlias : IDatabaseTypeAlias,
        Coder : IJsonModelCoder
    >(
        name: String
    ) -> Database.Table.Column.Json< TypeAlias, Coder > {
        return .init(table: self, name: name)
    }
    
}
