//
//  KindKit
//

extension Specifier.IEEE_1003 {
    
    public enum Index : Equatable {
        
        case auto
        case custom(UInt)
        
    }
    
}

extension Specifier.IEEE_1003.Index {
    
    init(_ pattern: Pattern.IEEE_1003) {
        switch pattern.index {
        case .some(let value): self = .custom(value - 1)
        case .none: self = .auto
        }
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        switch self {
        case .auto: break
        case .custom(let index): buffer.append("\(index)$")
        }
    }
    
}
