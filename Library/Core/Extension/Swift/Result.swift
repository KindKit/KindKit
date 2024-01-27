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
    
    @inlinable
    var success: Success? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
    
    @inlinable
    var failure: Failure? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
    
}

public extension Result where Success == Void {
    
    static var success: Self {
        return .success(())
    }
    
}

extension Result : MapTrait {
}
