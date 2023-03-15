//
//  KindKit
//

import Foundation

public final class AutoCancel : ICancellable {
    
    let object: ICancellable
    
    public init(
        _ object: ICancellable
    ) {
        self.object = object
    }
    
    deinit {
        self.cancel()
    }

    public func cancel() {
        self.object.cancel()
    }

}

public extension ICancellable {
    
    func autoCancel() -> AutoCancel {
        return AutoCancel(self)
    }
    
}
