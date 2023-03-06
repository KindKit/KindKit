//
//  KindKit
//

import Foundation

extension UI.View.PageBar.ContentLayout {
    
    enum IndicatorState {
        case empty
        case alias(current: IUIView)
        case transition(current: IUIView, next: IUIView, progress: Percent)
    }
    
}
