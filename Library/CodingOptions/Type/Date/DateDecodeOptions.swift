//
//  KindKit
//

public struct DateDecodeOptions : CodingOptions {
    
    public let formats: [DateRepresentable]
    
    fileprivate init(formats: [DateRepresentable]) {
        self.formats = formats
    }
    
}

public extension DateDecodeOptions {
    
    static func formats(_ formats: [DateRepresentable]) -> Self {
        return .init(formats: formats)
    }
    
}

extension DateDecodeOptions : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(formats: [
            .numberRepresentable(.unixtime),
            .stringRepresentable(.iso8601),
            .stringRepresentable(.iso8601WithoutMilliseconds)
        ])
    }
    
}
