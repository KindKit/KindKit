//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IWireframe {
    
    associatedtype Container : IContainer
    
    var container: Container { get }
    
}
