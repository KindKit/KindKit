//
//  KindKit
//

import Foundation

public protocol IUIStateContainer : IUIContainer, IUIContainerParentable {
    
    typealias ContentContainer = IUIContainer & IUIContainerParentable
    
    var content: ContentContainer? { set get }
    
}
