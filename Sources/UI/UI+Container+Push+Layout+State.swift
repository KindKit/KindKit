//
//  KindKit
//

import Foundation

extension UI.Container.Push.Layout {
    
    enum State : Equatable {
        
        case empty
        case idle(push: UI.Container.Push.Item)
        case present(push: UI.Container.Push.Item, progress: PercentFloat)
        case dismiss(push: UI.Container.Push.Item, progress: PercentFloat)
        
    }
    
}
