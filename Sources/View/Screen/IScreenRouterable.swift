//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IScreenRouterable {
    
    associatedtype AssociatedRouter
    
    var router: AssociatedRouter { get }
    
}
