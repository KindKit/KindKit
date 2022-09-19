//
//  KindKit
//

import Foundation

public protocol IUIBookContentContainer : IUIContainer, IUIContainerParentable {
    
    var bookIdentifier: Any { get }
    
}

public extension IUIBookContentContainer {
    
    var bookContainer: IUIBookContainer? {
        return self.parent as? IUIBookContainer
    }
    
}
