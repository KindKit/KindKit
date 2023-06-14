//
//  KindKit
//

import Foundation

public protocol IDatabaseValueCoder {
    
    associatedtype DatabaseCoded
    
    static func decode(_ value: Database.Value) throws -> DatabaseCoded
    static func encode(_ value: DatabaseCoded) throws -> Database.Value
    
}
