//
//  KindKit
//

#if os(iOS)

import UIKit

public protocol IInputToolbarItem : AnyObject {
    
    var barItem: UIBarButtonItem { get }
    
    func pressed()
    
}

public extension UI.View.Input.Toolbar {
    
    enum Item {
    }
    
}

#endif
