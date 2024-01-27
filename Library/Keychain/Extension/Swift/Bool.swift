//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Bool : ValueDecoderTrait {
    
    public typealias KeychainDecoded = Bool
    public typealias KeychainDecodeOptions = EmptyCodingOptions
    
    public static func keychain(decode value: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        guard let byte = value.first else {
            throw CodingError(in: key)
        }
        return byte != 0
    }
    
}

extension Bool : ValueEncoderTrait {
    
    public typealias KeychainEncoded = Bool
    public typealias KeychainEncodeOptions = EmptyCodingOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        switch value {
        case false: return Data([ 0 ])
        case true: return Data([ 1 ])
        }
    }
    
}
