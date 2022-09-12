//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public typealias IUserDefaultsCoderAlias = IUserDefaultsDecoderAlias & IUserDefaultsEncoderAlias

public protocol IUserDefaultsDecoderAlias {
    
    associatedtype UserDefaultsDecoder : IUserDefaultsValueDecoder
    
}

public protocol IUserDefaultsEncoderAlias {
    
    associatedtype UserDefaultsEncoder : IUserDefaultsValueEncoder
    
}
