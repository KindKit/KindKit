//
//  KindKit
//

import KindMonadicMacro

extension Specifier.IEEE_1003.Info {
    
    @KindMonadic
    public struct Oct : Equatable {
        
        @KindMonadicProperty
        public let alignment: Specifier.IEEE_1003.Alignment
        
        @KindMonadicProperty
        public let width: Specifier.IEEE_1003.Width
        
        @KindMonadicProperty
        public let length: Length
        
        public init(
            alignment: Specifier.IEEE_1003.Alignment,
            width: Specifier.IEEE_1003.Width,
            length: Length
        ) {
            self.alignment = alignment
            self.width = width
            self.length = length
        }
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    public static func oct(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        length: Specifier.IEEE_1003.Info.Oct.Length = .default
    ) -> Self {
        return .oct(.init(
            alignment: alignment,
            width: width,
            length: length
        ))
    }
    
    static func oct(_ pattern: Pattern.IEEE_1003) -> Self {
        return .oct(
            alignment: .init(pattern),
            width: .init(pattern),
            length: .init(pattern)
        )
    }
    
}

extension Specifier.IEEE_1003.Info.Oct {
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        self.alignment.append(&buffer)
        self.width.append(&buffer)
        self.length.append(&buffer)
        buffer.append("o")
    }

}
