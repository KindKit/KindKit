//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseTypeDeclaration {
    
    static var rawTypeDeclaration: String { get }
    static var typeDeclaration: String { get }
    
}
