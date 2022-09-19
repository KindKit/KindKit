//
//  KindKit
//

import Foundation

extension UI.Container.Dialog.Layout {
    
    enum State {
        case idle
        case present(progress: PercentFloat)
        case dismiss(progress: PercentFloat)
    }
    
}
