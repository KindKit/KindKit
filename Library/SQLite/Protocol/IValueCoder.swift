//
//  KindKit
//

import Foundation

public protocol IValueCoder {
    
    associatedtype SQLiteCoded
    
    static func decode(_ value: Value) throws -> SQLiteCoded
    static func encode(_ value: SQLiteCoded) throws -> Value
    
}
