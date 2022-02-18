//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IContext {
}

public protocol IContextable {
    
    associatedtype Context
    
    var context: Context { get }
    
}
