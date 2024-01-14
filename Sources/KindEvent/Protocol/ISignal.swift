//
//  KindKit
//

import KindCore

protocol ISignal : AnyObject {
    
    func remove(_ slot: ICancellable)
    
}
