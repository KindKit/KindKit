//
//  KindKit
//

import Foundation

public typealias IJsonValueCoder = IJsonValueDecoder & IJsonValueEncoder

public protocol IJsonValueDecoder {
    
    associatedtype JsonDecoded
    
    static func decode(_ value: IJsonValue) throws -> JsonDecoded
    
}

public protocol IJsonValueEncoder {
    
    associatedtype JsonEncoded

    static func encode(_ value: JsonEncoded) throws -> IJsonValue
    
}
