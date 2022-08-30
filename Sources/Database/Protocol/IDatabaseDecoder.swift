//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseDecoder {
    
    associatedtype Value
    
    func decode(_ statement: Database.Statement) throws -> Value
    
}
