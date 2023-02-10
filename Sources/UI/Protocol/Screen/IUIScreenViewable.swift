//
//  KindKit
//

import Foundation

public protocol IUIScreenViewable : AnyObject {
    
    associatedtype AssociatedView : IUIView
    
    var bar: UI.View.Bar? { get }
    var view: AssociatedView { get }
    var additionalContentInset: Inset { get }
    
    func apply(inset: UI.Container.AccumulateInset)
    
}

public extension IUIScreenViewable {
    
    var bar: UI.View.Bar? {
        return nil
    }
    
    var additionalContentInset: Inset {
        return .zero
    }
    
    func apply(inset: UI.Container.AccumulateInset) {
    }
    
}

public extension IUIScreenViewable where Self : IUIScreen, AssociatedView == UI.View.Scroll {
    
    func apply(inset: UI.Container.AccumulateInset, in view: UI.View.Scroll) {
        view.contentInset = inset.natural
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
