//
//  KindKit
//

import Foundation

public final class AutoCancel< Object : ICancellable > : ICancellable {
    
    let object: Object
    
    public init(
        _ object: Object
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
