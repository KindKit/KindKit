//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IRouterable {
    
    associatedtype AssociatedRouter
    
    var router: AssociatedRouter { get }
    
}
