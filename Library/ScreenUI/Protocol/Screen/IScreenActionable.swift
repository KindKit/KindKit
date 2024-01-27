//
//  KindKit
//

import KindUI

public protocol IScreenActionable : AnyObject {
    
    var actionBar: BarView { get }
    
}

extension IScreenActionable where Self : IScreenViewable {
    
    public var bar: BarView? {
        return self.actionBar
    }
    
}
