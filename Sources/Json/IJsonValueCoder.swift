//
//  KindKitJson
//

import Foundation

public typealias IJsonValueCoder = IJsonValueDecoder & IJsonValueEncoder

public protocol IJsonValueDecoder {
    
    associatedtype Value
    
    static func decode(_ value: IJsonValue) throws -> Value

}

public protocol IJsonValueEncoder {
    
    associatedtype Value

    static func encode(_ value: Value) throws -> IJsonValue

}
