//
//  KindKitJson
//

import Foundation

public typealias IJsonModelCoder = IJsonModelDecoder & IJsonModelEncoder

public protocol IJsonModelDecoder {
    
    associatedtype Model
    
    static func decode(_ json: Json) throws -> Model

}

public protocol IJsonModelEncoder {
    
    associatedtype Model

    static func encode(_ model: Model, json: Json) throws

}
