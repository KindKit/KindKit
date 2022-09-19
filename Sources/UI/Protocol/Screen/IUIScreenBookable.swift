//
//  KindKit
//

import Foundation

public protocol IUIScreenBookable : AnyObject {
    
    associatedtype AssociatedBookIdentifier
    
    var bookIdentifier: AssociatedBookIdentifier { get }
    
}

public extension IUIScreenBookable where Self : IUIScreen {
    
    @inlinable
    var bookContentContainer: IUIBookContentContainer? {
        guard let contentContainer = self.container as? IUIBookContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var bookContainer: IUIBookContainer? {
        return self.bookContentContainer?.bookContainer
    }
    
}
