//
//  KindKit
//

import Foundation

public typealias IValueCoder = IValueDecoder & IValueEncoder

public protocol IValueDecoder {
    
    associatedtype KeychainDecoded
    
    static func decode(_ value: Data) throws -> KeychainDecoded
    
}

public protocol IValueEncoder {
    
    associatedtype KeychainEncoded

    static func encode(_ value: KeychainEncoded) throws -> Data
    
}
