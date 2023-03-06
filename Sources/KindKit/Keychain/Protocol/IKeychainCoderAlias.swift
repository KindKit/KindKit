//
//  KindKit
//

import Foundation

public typealias IKeychainCoderAlias = IKeychainDecoderAlias & IKeychainEncoderAlias

public protocol IKeychainDecoderAlias {
    
    associatedtype KeychainDecoder : IKeychainValueDecoder
    
}

public protocol IKeychainEncoderAlias {
    
    associatedtype KeychainEncoder : IKeychainValueEncoder
    
}
