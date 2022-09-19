//
//  KindKit
//

import Foundation

public protocol IDatabaseValueDecoder {
    
    associatedtype DatabaseDecoded
    
    static func decode(_ value: Database.Value) throws -> DatabaseDecoded
    
}
