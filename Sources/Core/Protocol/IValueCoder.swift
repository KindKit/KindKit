//
//  KindKitCore
//

import Foundation

public protocol IValueDecoder {
    
    associatedtype Storage
    associatedtype Value
    
    static func decode(_ value: Storage) throws -> Value

}

public protocol IValueEncoder {
    
    associatedtype Storage
    associatedtype Value

    static func encode(_ value: Value) throws -> Storage

}
