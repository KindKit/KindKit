//
//  KindKit
//

#if os(iOS)

import UIKit

public protocol IInputToolbarItem : AnyObject {
    
    var barItem: UIBarButtonItem { get }
    
    func pressed()
    
}

#endif
