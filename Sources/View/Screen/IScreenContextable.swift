//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IContextable {
    
    associatedtype AssociatedContext
    
    var context: AssociatedContext { get }
    
}
