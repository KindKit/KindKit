//
//  KindKit
//

extension OptionalEncodeOptions {
    
    public enum Options : CodingOptions {
        
        case skippable
        case nullable
        
    }
    
}

extension OptionalEncodeOptions.Options : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .skippable
    }
    
}
