//
//  KindKit
//

import Foundation

public protocol IUIScreenActionable : AnyObject {
    
    var actionBar: UI.View.Bar { get }
    
}

extension IUIScreenActionable where Self : IUIScreenViewable {
    
    public var bar: UI.View.Bar? {
        return self.actionBar
    }
    
}
