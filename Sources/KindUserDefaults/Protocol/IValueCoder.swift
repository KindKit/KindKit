//
//  KindKit
//

public typealias IValueCoder = IValueDecoder & IValueEncoder

public protocol IValueDecoder {
    
    associatedtype UserDefaultsDecoded
    
    static func decode(_ value: IValue) throws -> UserDefaultsDecoded
    
}

public protocol IValueEncoder {
    
    associatedtype UserDefaultsEncoded

    static func encode(_ value: UserDefaultsEncoded) throws -> IValue
    
}
