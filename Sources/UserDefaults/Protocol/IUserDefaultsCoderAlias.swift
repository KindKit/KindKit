//
//  KindKitUserDefaults
//

import Foundation

public typealias IUserDefaultsCoderAlias = IUserDefaultsDecoderAlias & IUserDefaultsEncoderAlias

public protocol IUserDefaultsDecoderAlias {
    
    associatedtype UserDefaultsDecoderType : IUserDefaultsValueDecoder
    
}

public protocol IUserDefaultsEncoderAlias {
    
    associatedtype UserDefaultsEncoderType : IUserDefaultsValueEncoder
    
}
