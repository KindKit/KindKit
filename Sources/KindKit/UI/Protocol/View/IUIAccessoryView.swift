//
//  KindKit
//

import Foundation

public protocol IUIAccessoryView : IUIAnyView {
    
    var parentView: IUIView? { get }
    
    func appear(to view: IUIView)
    
}
