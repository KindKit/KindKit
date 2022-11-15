//
//  KindKit
//

import Foundation

extension UI.Container.Push {
    
    enum State : Equatable {
        
        case empty
        case idle(push: UI.Container.PushItem)
        case present(push: UI.Container.PushItem, progress: PercentFloat)
        case dismiss(push: UI.Container.PushItem, progress: PercentFloat)
        
    }
    
}
