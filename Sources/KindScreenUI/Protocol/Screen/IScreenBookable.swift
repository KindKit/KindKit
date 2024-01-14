//
//  KindKit
//

public protocol IScreenBookable : AnyObject {
    
    associatedtype AssociatedBookIdentifier
    
    var bookIdentifier: AssociatedBookIdentifier { get }
    
}

public extension IScreenBookable where Self : IScreen {
    
    @inlinable
    var bookContentContainer: IBookContentContainer? {
        guard let contentContainer = self.container as? IBookContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var bookContainer: IBookContainer? {
        return self.bookContentContainer?.bookContainer
    }
    
}
