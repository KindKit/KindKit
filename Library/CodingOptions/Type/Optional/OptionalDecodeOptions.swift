//
//  KindKit
//

public struct OptionalDecodeOptions< Wrapped : CodingOptions, Default > : CodingOptions {
    
    public let wrapped: Wrapped
    public let `default`: Default?
    
    fileprivate init(
        wrapped: Wrapped,
        `default`: Default?
    ) {
        self.wrapped = wrapped
        self.default = `default`
    }
    
}

extension OptionalDecodeOptions : @unchecked Sendable {
}

extension OptionalDecodeOptions : DefaultCodingOptions where Wrapped : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(wrapped: .default, default: nil)
    }
}

extension OptionalDecodeOptions where Self : DefaultCodingOptions {
    
    public static func `default`(_ value: Default) -> Self {
        return .init(wrapped: .default, default: value)
    }
    
}
