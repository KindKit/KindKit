//
//  KindKit
//

public protocol IContainerScreenable : AnyObject {
    
    associatedtype Screen: IScreen
    
    var screen: Screen { get }
    
}
