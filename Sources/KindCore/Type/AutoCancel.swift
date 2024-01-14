//
//  KindKit
//

import Foundation

public final class AutoCancel {
    
    let object: ICancellable
    
    public init(
        _ object: ICancellable
    ) {
        self.object = object
    }
    
    deinit {
        self.cancel()
    }
    
}

extension AutoCancel : ICancellable {
    
    public func cancel() {
        self.object.cancel()
    }

}

public extension ICancellable {
    
    @inlinable
    func autoCancel() -> AutoCancel {
        return AutoCancel(self)
    }
    
}
