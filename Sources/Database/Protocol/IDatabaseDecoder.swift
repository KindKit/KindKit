//
//  KindKit
//

import Foundation

public protocol IDatabaseDecoder {
    
    associatedtype DatabaseDecoded
    
    func decode(_ statement: Database.Statement) throws -> DatabaseDecoded
    
}
