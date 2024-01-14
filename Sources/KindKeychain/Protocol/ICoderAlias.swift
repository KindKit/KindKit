//
//  KindKit
//

public typealias ICoderAlias = IDecoderAlias & IEncoderAlias

public protocol IDecoderAlias {
    
    associatedtype KeychainDecoder : IValueDecoder
    
}

public protocol IEncoderAlias {
    
    associatedtype KeychainEncoder : IValueEncoder
    
}
