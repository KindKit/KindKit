//
//  KindKit
//

import Foundation

extension UI.View.PageBar.ContentLayout {
    
    enum IndicatorState {
        case empty
        case alias(current: UI.Layout.Item)
        case transition(current: UI.Layout.Item, next: UI.Layout.Item, progress: PercentFloat)
    }
    
}
