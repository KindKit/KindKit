//
//  KindKit
//

extension Specifier.IEEE_1003.Info {
    
    public enum Number : Equatable {
    
        case signed(Signed)
        case unsigned(Unsigned)
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    public static func numberSigned(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        length: Specifier.IEEE_1003.Info.Number.Length = .default,
        flags: Specifier.IEEE_1003.Info.Number.Signed.Flags = []
    ) -> Self {
        return .number(.signed(
            alignment: alignment,
            width: width,
            length: length,
            flags: flags
        ))
    }
    
    public static func numberUnsigned(
        alignment: Specifier.IEEE_1003.Alignment = .right,
        width: Specifier.IEEE_1003.Width = .default,
        length: Specifier.IEEE_1003.Info.Number.Length = .default,
        flags: Specifier.IEEE_1003.Info.Number.Unsigned.Flags = []
    ) -> Self {
        return .number(.unsigned(
            alignment: alignment,
            width: width,
            length: length,
            flags: flags
        ))
    }
    
    static func numberSigned(_ pattern: Pattern.IEEE_1003) -> Self {
        return .number(.signed(pattern))
    }
    
    static func numberUnsigned(_ pattern: Pattern.IEEE_1003) -> Self {
        return .number(.unsigned(pattern))
    }
    
}

extension Specifier.IEEE_1003.Info.Number {
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        switch self {
        case .signed(let info): info.append(&buffer)
        case .unsigned(let info): info.append(&buffer)
        }
    }

}
