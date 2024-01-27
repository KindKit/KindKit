//
//  KindKit
//

public struct ArrayEncodeOptions< Element : CodingOptions > : CodingOptions {
    
    public let element: Element
    public let sequence: SequenceCodingOptions
    
    fileprivate init(
        element: Element,
        sequence: SequenceCodingOptions
    ) {
        self.element = element
        self.sequence = sequence
    }
    
}

extension ArrayEncodeOptions : DefaultCodingOptions where Element : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(element: .default, sequence: .default)
    }
    
}

public extension ArrayEncodeOptions {
    
    static func nonEmpty(_ element: Element) -> Self {
        return .init(element: element, sequence: .nonEmpty)
    }
    
    static func skipInvalid(_ element: Element) -> Self {
        return .init(element: element, sequence: .skipInvalid)
    }
    
}

public extension ArrayEncodeOptions where Self : DefaultCodingOptions {
    
    static var nonEmpty: Self {
        return .init(element: .default, sequence: .nonEmpty)
    }
    
    static var skipInvalid: Self {
        return .init(element: .default, sequence: .skipInvalid)
    }
    
}
