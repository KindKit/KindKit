//
//  KindKit
//

import Foundation

public typealias IValueCoder = IValueDecoder & IValueEncoder

public protocol IValueDecoder {
    
    associatedtype JsonDecoded
    
    static func decode(_ value: IValue, path: Path) throws -> JsonDecoded
    
}

public protocol IValueEncoder {
    
    associatedtype JsonEncoded

    static func encode(_ value: JsonEncoded, path: Path) throws -> IValue
    
}
