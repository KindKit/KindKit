//
//  KindKit
//

import Foundation

public final class AutoCancel {
    
    let object: CancelTrait
    
    public init(
        _ object: CancelTrait
    ) {
        self.object = object
    }
    
    deinit {
        self.cancel()
    }
    
}

extension AutoCancel : CancelTrait {
    
    public func cancel() {
        self.object.cancel()
    }

}

public extension CancelTrait {
    
    @inlinable
    func autoCancel() -> AutoCancel {
        return AutoCancel(self)
    }
    
}
