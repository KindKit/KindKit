//
//  KindKit
//

import Foundation

public protocol IUIContainerScreenable : AnyObject {
    
    associatedtype Screen: IUIScreen
    
    var screen: Screen { get }
    
}
