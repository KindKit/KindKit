//
//  KindKit
//

import Foundation

public protocol IUIContainerScreenable : AnyObject {
    
    associatedtype Screen: IScreen
    
    var screen: Screen { get }
    
}
