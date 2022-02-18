//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public protocol IContainerScreenable : AnyObject {
    
    associatedtype Screen : IScreen
    
    var screen: Screen { get }
    
}
