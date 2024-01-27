//
//  KindKit
//

extension BundleFinder {
    
    public enum Table {
        
        case `default`
        
        case custom(String)
        
    }
    
}

public extension BundleFinder.Table {
    
    @inlinable
    var name: String? {
        switch self {
        case .default: return nil
        case .custom(let name): return name
        }
    }
    
}
