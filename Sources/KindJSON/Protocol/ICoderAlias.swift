//
//  KindKit
//

import Foundation

public typealias ICoderAlias = IDecoderAlias & IEncoderAlias

public protocol IDecoderAlias {
    
    associatedtype JsonDecoder : IValueDecoder
    
}

public protocol IEncoderAlias {
    
    associatedtype JsonEncoder : IValueEncoder
    
}
