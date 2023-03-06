//
//  KindKit
//

import Foundation

public typealias IUserDefaultsValueCoder = IUserDefaultsValueDecoder & IUserDefaultsValueEncoder

public protocol IUserDefaultsValueDecoder {
    
    associatedtype UserDefaultsDecoded
    
    static func decode(_ value: IUserDefaultsValue) throws -> UserDefaultsDecoded
    
}

public protocol IUserDefaultsValueEncoder {
    
    associatedtype UserDefaultsEncoded

    static func encode(_ value: UserDefaultsEncoded) throws -> IUserDefaultsValue
    
}
