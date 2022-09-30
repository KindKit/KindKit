//
//  KindKit
//

import Foundation

extension UI.Container.Hamburger.Layout {
    
    enum State : Equatable {
        
        case idle
        case leading(progress: PercentFloat)
        case trailing(progress: PercentFloat)
        
    }
    
}
