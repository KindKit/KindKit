//
//  KindKit
//

import Foundation

extension Identifier : ITypeAlias where RawType : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = RawType.SQLiteTypeDeclaration
    
}
