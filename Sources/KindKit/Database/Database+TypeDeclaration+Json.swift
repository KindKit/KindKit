//
//  KindKit
//

import Foundation

extension IDatabaseValueAlias where Self : IJsonModelCoder, JsonModelDecoded == JsonModelEncoded {
    
    public typealias DatabaseTypeDeclaration = Json.DatabaseTypeDeclaration
    
}

extension Json : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Blob
    
}
