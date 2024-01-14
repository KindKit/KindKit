//
//  KindKit
//

import Foundation

public protocol IRootContentContainer : IContainer, IContainerParentable {
    
    var rootContainer: Container.Root? { get }
    
}

public extension IRootContentContainer {
    
    @inlinable
    var rootContainer: Container.Root? {
        return self.parent as? Container.Root
    }
    
}
