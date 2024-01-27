//
//  KindKit
//

public struct DateEncodeOptions : CodingOptions {
    
    public let format: DateRepresentable
    
    fileprivate init(format: DateRepresentable) {
        self.format = format
    }
    
}

public extension DateEncodeOptions {
    
    static func format(_ format: DateRepresentable) -> Self {
        return .init(format: format)
    }
    
}

extension DateEncodeOptions : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(
            format: .stringRepresentable(.iso8601)
        )
    }
    
}
