//
//  KindKit
//

import KindMath

extension PageBarView.ContentLayout {
    
    enum IndicatorState {
        case empty
        case alias(current: IView)
        case transition(current: IView, next: IView, progress: Percent)
    }
    
}
