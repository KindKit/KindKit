//
//  KindKitCore
//

import Foundation

public protocol IValueDecoder {
    
    associatedtype StorageType
    associatedtype ValueType
    
    static func decode(_ value: StorageType) throws -> ValueType

}

public protocol IValueEncoder {
    
    associatedtype StorageType
    associatedtype ValueType

    static func encode(_ value: ValueType) throws -> StorageType

}
