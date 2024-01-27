//
//  KindKit
//

public struct URLEncodeOptions : CodingOptions {
    
    public let removing: URLComponentOptions
    
    fileprivate init(
        removing: URLComponentOptions
    ) {
        self.removing = removing
    }
    
}

public extension URLEncodeOptions {
    
    static func removing(_ components: URLComponentOptions) -> Self {
        return .init(removing: components)
    }
    
}

extension URLEncodeOptions : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(removing: [])
    }
    
}
