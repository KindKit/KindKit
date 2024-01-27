//
//  KindKit
//

import KindMonadicMacro

extension Specifier.IEEE_1003.Info {
    
    @KindMonadic
    public struct Pointer : Equatable {
    
        @KindMonadicProperty
        public let alignment: Specifier.IEEE_1003.Alignment
        
        public init(
            alignment: Specifier.IEEE_1003.Alignment
        ) {
            self.alignment = alignment
        }
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    public static func pointer(
        alignment: Specifier.IEEE_1003.Alignment = .right
    ) -> Self {
        return .pointer(.init(
            alignment: alignment
        ))
    }
    
    static func pointer(_ pattern: Pattern.IEEE_1003) -> Self {
        return .pointer(
            alignment: .init(pattern)
        )
    }
    
}

extension Specifier.IEEE_1003.Info.Pointer {
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        self.alignment.append(&buffer)
        buffer.append("p")
    }

}
