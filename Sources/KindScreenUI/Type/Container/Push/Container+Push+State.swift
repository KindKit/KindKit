//
//  KindKit
//

import KindMath

extension Container.Push {
    
    enum State : Equatable {
        
        case empty
        case idle(push: Container.PushItem)
        case present(push: Container.PushItem, progress: Percent)
        case dismiss(push: Container.PushItem, progress: Percent)
        
    }
    
}
