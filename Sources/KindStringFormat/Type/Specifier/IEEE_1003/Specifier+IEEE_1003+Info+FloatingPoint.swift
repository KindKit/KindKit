//
//  KindKit
//

import KindMonadicMacro

extension Specifier.IEEE_1003.Info {
    
    @KindMonadic
    public struct FloatingPoint : Equatable {
        
        @KindMonadicProperty
        public let alignment: Specifier.IEEE_1003.Alignment

        @KindMonadicProperty
        public let width: Specifier.IEEE_1003.Width

        @KindMonadicProperty
        public let precision: Specifier.IEEE_1003.Precision
        
        @KindMonadicProperty
        public let length: Length
        
        @KindMonadicProperty
        public let notation: Notation

        @KindMonadicProperty
        public let flags: Flags
        
        public init(
            alignment: Specifier.IEEE_1003.Alignment,
            width: Specifier.IEEE_1003.Width,
            precision: Specifier.IEEE_1003.Precision,
            length: Length,
            notation: Notation,
            flags: Flags
        ) {
            self.alignment = alignment
            self.width = width
            self.precision = precision
            self.length = length
            self.notation = notation
            self.flags = flags
        }
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    public static func floatingPoint(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        precision: Specifier.IEEE_1003.Precision = .default,
        length: Specifier.IEEE_1003.Info.FloatingPoint.Length = .default,
        notation: Specifier.IEEE_1003.Info.FloatingPoint.Notation = .normal,
        flags: Specifier.IEEE_1003.Info.FloatingPoint.Flags = []
    ) -> Self {
        return .floatingPoint(.init(
            alignment: alignment,
            width: width,
            precision: precision,
            length: length,
            notation: notation,
            flags: flags
        ))
    }
    
    static func floatingPoint(
        _ pattern: Pattern.IEEE_1003,
        notation: Specifier.IEEE_1003.Info.FloatingPoint.Notation = .normal,
        flags: Specifier.IEEE_1003.Info.FloatingPoint.Flags = []
    ) -> Self {
        var flags = flags
        if pattern.flags.contains("0") == true {
            flags.insert(.zero)
        }
        if pattern.flags.contains("+") == true {
            flags.insert(.sign)
        }
        return .floatingPoint(
            alignment: .init(pattern),
            width: .init(pattern),
            precision: .init(pattern),
            length: .init(pattern),
            notation: notation,
            flags: flags
        )
    }
    
}

extension Specifier.IEEE_1003.Info.FloatingPoint {
    
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
        self.precision.append(&buffer)
        self.length.append(&buffer)
        if self.flags.contains(.hex) == true {
            if self.flags.contains(.uppercase) == true {
                buffer.append("A")
            } else {
                buffer.append("a")
            }
        } else {
            switch self.notation {
            case .normal:
                if self.flags.contains(.uppercase) == true {
                    buffer.append("F")
                } else {
                    buffer.append("f")
                }
            case .exponent:
                if self.flags.contains(.uppercase) == true {
                    buffer.append("E")
                } else {
                    buffer.append("e")
                }
            case .auto:
                if self.flags.contains(.uppercase) == true {
                    buffer.append("G")
                } else {
                    buffer.append("g")
                }
            }
        }
    }

}
