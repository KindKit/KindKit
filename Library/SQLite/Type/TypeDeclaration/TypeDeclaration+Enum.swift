//
//  KindKit
//

import Foundation

extension ITypeAlias where Self : IEnumCodable, RawValue : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = RawValue.SQLiteTypeDeclaration
    
}
