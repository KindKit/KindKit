//
//  KindKit
//

extension Specifier.IEEE_1003 {
    
    public enum Alignment : Equatable {
        
        case left
        case right
        
    }
    
}

extension Specifier.IEEE_1003.Alignment {
    
    init(_ raw: Pattern.IEEE_1003) {
        switch raw.flags {
        case "-": self = .left
        default: self = .right
        }
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        switch self {
        case .left: buffer.append("-")
        case .right: break
        }
    }

}
