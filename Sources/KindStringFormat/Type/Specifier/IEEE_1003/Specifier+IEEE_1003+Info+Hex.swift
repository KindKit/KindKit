//
//  KindKit
//

import KindMonadicMacro

extension Specifier.IEEE_1003.Info {
    
    @KindMonadic
    public struct Hex : Equatable {
        
        @KindMonadicProperty
        public let alignment: Specifier.IEEE_1003.Alignment
        
        @KindMonadicProperty
        public let width: Specifier.IEEE_1003.Width
        
        @KindMonadicProperty
        public let length: Length
        
        @KindMonadicProperty
        public let flags: Flags
        
        public init(
            alignment: Specifier.IEEE_1003.Alignment,
            width: Specifier.IEEE_1003.Width,
            length: Length,
            flags: Flags
        ) {
            self.alignment = alignment
            self.width = width
            self.length = length
            self.flags = flags
        }
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    public static func hex(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        length: Specifier.IEEE_1003.Info.Hex.Length = .default,
        flags: Specifier.IEEE_1003.Info.Hex.Flags = []
    ) -> Self {
        return .hex(.init(
            alignment: alignment,
            width: width,
            length: length,
            flags: flags
        ))
    }
    
    static func hex(
        _ pattern: Pattern.IEEE_1003,
        flags: Specifier.IEEE_1003.Info.Hex.Flags = []
    ) -> Self {
        var flags = flags
        if pattern.flags == "#" {
            flags.insert(.prefix)
        }
        return .hex(
            alignment: .init(pattern),
            width: .init(pattern),
            length: .init(pattern),
            flags: flags
        )
    }
    
}

extension Specifier.IEEE_1003.Info.Hex {
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        self.alignment.append(&buffer)
        if self.flags.contains(.prefix) == true {
            buffer.append("#")
        }
        self.width.append(&buffer)
        self.length.append(&buffer)
        if self.flags.contains(.uppercase) == true {
            buffer.append("X")
        } else {
            buffer.append("x")
        }
    }

}
