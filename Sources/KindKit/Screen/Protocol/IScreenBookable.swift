//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenBookable")
public typealias IUIScreenBookable = IScreenBookable

public protocol IScreenBookable : AnyObject {
    
    associatedtype AssociatedBookIdentifier
    
    var bookIdentifier: AssociatedBookIdentifier { get }
    
}

public extension IScreenBookable where Self : IScreen {
    
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
