//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IRouter : AnyObject {
}

public protocol IRouterable {
    
    associatedtype Router = IRouter
    
    var router: Router? { get }
    
}
