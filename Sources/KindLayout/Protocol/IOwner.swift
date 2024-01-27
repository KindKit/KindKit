//
//  KindKit
//

import KindCore

public protocol IOwner : AnyObject, IBatchUpdate {
    
    func invalidate()
    
}
