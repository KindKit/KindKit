//
//  KindKit
//

public protocol IBookContentContainer : IContainer, IContainerParentable {
    
    var bookIdentifier: Any { get }
    
}

public extension IBookContentContainer {
    
    @inlinable
    var bookContainer: IBookContainer? {
        return self.parent as? IBookContainer
    }
    
}
