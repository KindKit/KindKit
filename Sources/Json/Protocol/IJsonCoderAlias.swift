//
//  KindKitJson
//

import Foundation

public typealias IJsonCoderAlias = IJsonDecoderAlias & IJsonEncoderAlias

public protocol IJsonDecoderAlias {
    
    associatedtype JsonDecoderType : IJsonValueDecoder
    
}

public protocol IJsonEncoderAlias {
    
    associatedtype JsonEncoderType : IJsonValueEncoder
    
}
