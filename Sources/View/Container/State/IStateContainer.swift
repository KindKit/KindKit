//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStateContainer : IContainer, IContainerParentable {
    
    typealias ContentContainer = IContainer & IContainerParentable
    
    var container: ContentContainer? { set get }
    
}
