//
//  KindKit
//

import KindMonadicMacro

extension Specifier.IEEE_1003.Info.Number {
    
    @KindMonadic
    public struct Signed : Equatable {
    
        @KindMonadicProperty
        public let alignment: Specifier.IEEE_1003.Alignment
        
        @KindMonadicProperty
        public let width: Specifier.IEEE_1003.Width
        
        @KindMonadicProperty
        public let length: Specifier.IEEE_1003.Info.Number.Length
        
        @KindMonadicProperty
        public let flags: Flags
        
        public init(
            alignment: Specifier.IEEE_1003.Alignment,
            width: Specifier.IEEE_1003.Width,
            length: Specifier.IEEE_1003.Info.Number.Length,
            flags: Flags
        ) {
            self.alignment = alignment
            self.width = width
            self.length = length
            self.flags = flags
        }
        
    }
    
}

extension Specifier.IEEE_1003.Info.Number {
    
    public static func signed(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        length: Specifier.IEEE_1003.Info.Number.Length = .default,
        flags: Specifier.IEEE_1003.Info.Number.Signed.Flags = []
    ) -> Self {
        return .signed(.init(
            alignment: alignment,
            width: width,
            length: length,
            flags: flags
        ))
    }
    
    static func signed(_ pattern: Pattern.IEEE_1003) -> Self {
        var flags: Specifier.IEEE_1003.Info.Number.Signed.Flags = []
        if pattern.flags.contains("0") == true {
            flags.insert(.zero)
        }
        if pattern.flags.contains("+") == true {
            flags.insert(.sign)
        }
        return .signed(
            alignment: .init(pattern),
            width: .init(pattern),
            length: .init(pattern),
            flags: flags
        )
    }
    
}

extension Specifier.IEEE_1003.Info.Number.Signed {
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        self.alignment.append(&buffer)
        if self.flags.contains(.sign) == true {
            buffer.append("+")
        }
        if self.flags.contains(.zero) == true {
            buffer.append("0")
        }
        self.width.append(&buffer)
        self.length.append(&buffer)
        buffer.append("d")
    }

}
