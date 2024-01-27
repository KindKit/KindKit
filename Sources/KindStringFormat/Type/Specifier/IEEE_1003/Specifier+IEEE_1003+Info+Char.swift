//
//  KindKit
//

import KindMonadicMacro

extension Specifier.IEEE_1003.Info {
    
    @KindMonadic
    public struct Char : Equatable {
        
        @KindMonadicProperty
        public let alignment: Specifier.IEEE_1003.Alignment

        @KindMonadicProperty
        public let width: Specifier.IEEE_1003.Width
        
        @KindMonadicProperty
        public let length: Specifier.IEEE_1003.StringLength
        
        public init(
            alignment: Specifier.IEEE_1003.Alignment,
            width: Specifier.IEEE_1003.Width,
            length: Specifier.IEEE_1003.StringLength
        ) {
            self.alignment = alignment
            self.width = width
            self.length = length
        }
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    public static func char(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        length: Specifier.IEEE_1003.StringLength = .utf8
    ) -> Self {
        return .char(.init(
            alignment: alignment,
            width: width,
            length: length
        ))
    }
    
    static func char(
        _ pattern: Pattern.IEEE_1003,
        length: Specifier.IEEE_1003.StringLength = .utf8
    ) -> Self {
        return .char(
            alignment: .init(pattern),
            width: .init(pattern),
            length: length
        )
    }
    
}

extension Specifier.IEEE_1003.Info.Char {
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        self.alignment.append(&buffer)
        self.width.append(&buffer)
        switch self.length {
        case .utf8: buffer.append("c")
        case .utf16: buffer.append("C")
        }
    }

}
