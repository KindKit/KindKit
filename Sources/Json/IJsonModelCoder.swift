//
//  KindKitJson
//

import Foundation

public typealias IJsonModelCoder = IJsonModelDecoder & IJsonModelEncoder

public protocol IJsonModelDecoder {
    
    associatedtype Value
    
    static func decode(_ json: Json) throws -> Value

}

public protocol IJsonModelEncoder {
    
    associatedtype Value

    static func encode(_ model: Value, json: Json) throws

}
