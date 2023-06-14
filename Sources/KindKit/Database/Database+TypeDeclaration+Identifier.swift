//
//  KindKit
//

import Foundation

extension Identifier : IDatabaseTypeAlias where Raw : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Raw.DatabaseTypeDeclaration
    
}
