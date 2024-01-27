//
//  KindKit
//

import KindJSON

extension IValueAlias where Self : KindJSON.IModelCoder, JsonModelDecoded == JsonModelEncoded {
    
    public typealias SQLiteTypeDeclaration = KindJSON.Document.SQLiteTypeDeclaration
    
}

extension KindJSON.Document : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Blob
    
}
