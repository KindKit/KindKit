//
//  KindKit
//

public struct EmptyCodingOptions : CodingOptions {
    
    public init() {
    }
    
}

extension EmptyCodingOptions : DefaultCodingOptions {
    
    @inlinable
    public static var `default`: Self {
        return .init()
    }
    
}
