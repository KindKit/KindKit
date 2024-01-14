//
//  KindKit
//

public extension Result {
    
    @inlinable
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    @inlinable
    var isFailure: Bool {
        switch self {
        case .success: return false
        case .failure: return true
        }
    }
    
}
