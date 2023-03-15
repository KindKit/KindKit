//
//  KindKit
//

import Foundation

public typealias IJsonModelCoder = IJsonModelDecoder & IJsonModelEncoder

public protocol IJsonModelDecoder {
    
    associatedtype JsonModelDecoded
    
    static func decode(_ json: Json) throws -> JsonModelDecoded

}

public protocol IJsonModelEncoder {
    
    associatedtype JsonModelEncoded

    static func encode(_ model: JsonModelEncoded, json: Json) throws

}
