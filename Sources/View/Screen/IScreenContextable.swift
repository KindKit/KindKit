//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IScreenContextable {
    
    associatedtype AssociatedContext
    
    var context: AssociatedContext { get }
    
}
