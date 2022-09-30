//
//  KindKit
//

import Foundation

extension UI.Container.Dialog.Layout {
    
    enum State : Equatable {
        case idle
        case present(progress: PercentFloat)
        case dismiss(progress: PercentFloat)
    }
    
}
