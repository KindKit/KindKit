//
//  KindKitJson
//

import Foundation
import KindKitCore

public typealias IJsonCoderAlias = IJsonDecoderAlias & IJsonEncoderAlias

public protocol IJsonDecoderAlias {
    
    associatedtype JsonDecoder : IJsonValueDecoder
    
}

public protocol IJsonEncoderAlias {
    
    associatedtype JsonEncoder : IJsonValueEncoder
    
}
