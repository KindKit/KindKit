//
//  KindKit
//

import Foundation
import KindMonadicMacro

extension Specifier.IEEE_1003.Info {
    
    @KindMonadic
    public struct String : Equatable {
        
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
    
    public static func string(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        length: Specifier.IEEE_1003.StringLength = .utf8
    ) -> Self {
        return .string(.init(
            alignment: alignment,
            width: width,
            length: length
        ))
    }
    
    static func string(
        _ pattern: Pattern.IEEE_1003,
        length: Specifier.IEEE_1003.StringLength = .utf8
    ) -> Self {
        return .string(
            alignment: .init(pattern),
            width: .init(pattern),
            length: length
        )
    }
    
}

extension Specifier.IEEE_1003.Info.String {
    
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
        case .utf8: buffer.append("s")
        case .utf16: buffer.append("S")
        }
    }

}
