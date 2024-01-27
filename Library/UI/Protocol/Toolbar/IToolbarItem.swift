//
//  KindKit
//

#if os(iOS)

import UIKit

public protocol IToolbarItem : AnyObject, Equatable {
    
    var handle: UIBarButtonItem { get }
    
    func pressed()
    
}

extension IToolbarItem {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
}

#endif
