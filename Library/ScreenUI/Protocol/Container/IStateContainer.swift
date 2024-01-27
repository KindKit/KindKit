//
//  KindKit
//

public protocol IStateContainer : IContainer, IContainerParentable {
    
    typealias ContentContainer = IContainer & IContainerParentable
    
    var content: ContentContainer? { set get }
    
}
