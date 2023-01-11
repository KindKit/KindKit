//
//  KindKit
//

import Foundation

public typealias IKeychainValueCoder = IKeychainValueDecoder & IKeychainValueEncoder

public protocol IKeychainValueDecoder {
    
    associatedtype KeychainDecoded
    
    static func decode(_ value: Data) throws -> KeychainDecoded
    
}

public protocol IKeychainValueEncoder {
    
    associatedtype KeychainEncoded

    static func encode(_ value: KeychainEncoded) throws -> Data
    
}
