//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenActionable")
public typealias IUIScreenActionable = IScreenActionable

public protocol IScreenActionable : AnyObject {
    
    var actionBar: UI.View.Bar { get }
    
}

extension IScreenActionable where Self : IScreenViewable {
    
    public var bar: UI.View.Bar? {
        return self.actionBar
    }
    
}
