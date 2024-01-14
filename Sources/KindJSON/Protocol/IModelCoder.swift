//
//  KindKit
//

import Foundation

public typealias IModelCoder = IModelDecoder & IModelEncoder

public protocol IModelDecoder {
    
    associatedtype JsonModelDecoded
    
    static func decode(_ json: Document) throws -> JsonModelDecoded

}

public protocol IModelEncoder {
    
    associatedtype JsonModelEncoded

    static func encode(_ model: JsonModelEncoded, json: Document) throws

}
