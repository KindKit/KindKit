//
//  KindKit
//

public struct OptionalEncodeOptions< Wrapped : CodingOptions > : CodingOptions {
    
    public let wrapped: Wrapped
    public let options: Options
    
    fileprivate init(
        wrapped: Wrapped,
        options: Options = .default
    ) {
        self.wrapped = wrapped
        self.options = options
    }
    
}

extension OptionalEncodeOptions {
    
    public static func skippable(_ wrapped: Wrapped) -> Self {
        return .init(wrapped: wrapped, options: .skippable)
    }
    
    public static func nullable(_ wrapped: Wrapped) -> Self {
        return .init(wrapped: wrapped, options: .nullable)
    }
    
}

extension OptionalEncodeOptions : DefaultCodingOptions where Wrapped : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(wrapped: .default, options: .default)
    }
    
}

extension OptionalEncodeOptions where Self : DefaultCodingOptions {
    
    public static var skippable: Self {
        return .init(wrapped: .default, options: .skippable)
    }
    
    public static var nullable: Self {
        return .init(wrapped: .default, options: .nullable)
    }
    
}
