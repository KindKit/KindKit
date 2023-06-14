//
//  KindKit
//

import Foundation

extension IDatabaseTypeAlias where Self : IEnumCodable, RawValue : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = RawValue.DatabaseTypeDeclaration
    
}
