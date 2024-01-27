//
//  KindKit
//

import KindJSON

public final class Table : ITable {
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
}

public extension Table {
    
    func column<
        Alias : IValueAlias
    >(
        name: String
    ) -> Table.Column.Alias< Alias > {
        return .init(table: self, name: name)
    }
    
    func column<
        TypeDeclaration : ITypeDeclaration,
        ValueCoder : IValueCoder
    >(
        name: String
    ) -> Table.Column.Custom< TypeDeclaration, ValueCoder > {
        return .init(table: self, name: name)
    }
    
    func column<
        TypeAlias : ITypeAlias,
        Coder : KindJSON.IModelCoder
    >(
        name: String
    ) -> Table.Column.Json< TypeAlias, Coder > {
        return .init(table: self, name: name)
    }
    
}
