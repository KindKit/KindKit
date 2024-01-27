//
//  KindKit
//

import KindStringScanner
import KindMonadicMacro

extension Specifier {
    
    @Monadic
    public struct IEEE_1003 : Equatable {
        
        @MonadicField
        public let index: Index
        
        @MonadicField
        public let info: Info
        
        public init(
            index: Index = .auto,
            info: Info
        ) {
            self.index = index
            self.info = info
        }
        
    }
    
}

extension Specifier.IEEE_1003 {
    
    init?(_ pattern: Pattern.IEEE_1003) {
        guard let info = Info(pattern) else { return nil }
        self.index = .init(pattern)
        self.info = info
    }
    
}

public extension Specifier.IEEE_1003 {
    
    static var placeholder: Self {
        return .init(info: .placeholder)
    }
    
    var string: String {
        var buffer = "%"
        self.index.append(&buffer)
        self.info.append(&buffer)
        return buffer
    }
    
    var placeholder: String? {
        switch self.info {
        case .placeholder: return "%"
        default: return nil
        }
    }
    
    init?(_ string: String) {
        guard let match = Pattern.IEEE_1003(string) else { return nil }
        self.init(match)
    }
    
    func format< Value : BinaryInteger >(_ value: Value) -> String? {
        return self.info.format(value)
    }
    
    func format< Value : BinaryFloatingPoint >(_ value: Value) -> String? {
        return self.info.format(value)
    }
    
    func format(_ value: String) -> String? {
        return self.info.format(value)
    }
    
}
