//
//  KindKit
//

extension Specifier.IEEE_1003 {
    
    public enum Precision : Equatable {
        
        case `default`
        case fixed(UInt)
        
    }
    
}

extension Specifier.IEEE_1003.Precision {
    
    init(_ pattern: Pattern.IEEE_1003) {
        switch pattern.precision {
        case .some(let value):
            if value > 0 {
                self = .fixed(value)
            } else {
                self = .default
            }
        case .none:
            self = .default
        }
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        switch self {
        case .default: break
        case .fixed(let value): buffer.append(".\(value)")
        }
    }

}
