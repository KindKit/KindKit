//
//  KindKit
//

import Foundation

public protocol IDatabaseTableColumn {
    
    associatedtype DatabaseTypeDeclaration : IDatabaseTypeDeclaration
    associatedtype DatabaseValueCoder : IDatabaseValueCoder
    
    var table: IDatabaseTable { get }
    var name: String { get }

}
