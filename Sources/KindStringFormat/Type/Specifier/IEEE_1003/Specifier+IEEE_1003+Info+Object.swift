//
//  KindKit
//

import KindMonadicMacro

extension Specifier.IEEE_1003.Info {
    
    @KindMonadic
    public struct Object : Equatable {
    
        @KindMonadicProperty
        public let alignment: Specifier.IEEE_1003.Alignment
        
        @KindMonadicProperty
        public let width: Specifier.IEEE_1003.Width
        
        public init(
            alignment: Specifier.IEEE_1003.Alignment,
            width: Specifier.IEEE_1003.Width
        ) {
            self.alignment = alignment
            self.width = width
        }
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    public static func object(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default
    ) -> Self {
        return .object(.init(
            alignment: alignment,
            width: width
        ))
    }
    
    static func object(_ pattern: Pattern.IEEE_1003) -> Self {
        return .object(
            alignment: .init(pattern),
            width: .init(pattern)
        )
    }
    
}

extension Specifier.IEEE_1003.Info.Object {
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        self.alignment.append(&buffer)
        self.width.append(&buffer)
        buffer.append("@")
    }

}
