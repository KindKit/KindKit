//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IAccessoryView : IBaseView {
    
    var parentView: IView? { get }
    
    func appear(to view: IView)
    
}
