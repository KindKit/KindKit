//
//  KindKit
//

import Foundation

final class AutoCancel< Object : ICancellable > : ICancellable {
    
    let object: Object
    
    init(
        _ object: Object
    ) {
        self.object = object
    }
    
    deinit {
        self.cancel()
    }

    func cancel() {
        self.object.cancel()
    }

}
