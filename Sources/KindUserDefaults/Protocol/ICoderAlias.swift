//
//  KindKit
//

public typealias ICoderAlias = IDecoderAlias & IEncoderAlias

public protocol IDecoderAlias {
    
    associatedtype UserDefaultsDecoder : IValueDecoder
    
}

public protocol IEncoderAlias {
    
    associatedtype UserDefaultsEncoder : IValueEncoder
    
}
