//
//  KindKitJson
//

import Foundation

public typealias IJsonModelCoder = IJsonModelDecoder & IJsonModelEncoder

public protocol IJsonModelDecoder {
    
    associatedtype ModelType
    
    static func decode(_ json: Json) throws -> ModelType

}

public protocol IJsonModelEncoder {
    
    associatedtype ModelType

    static func encode(_ model: ModelType, json: Json) throws

}
