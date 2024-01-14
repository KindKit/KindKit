//
//  KindKit
//

import KindUI

public protocol IScreenViewable : AnyObject {
    
    associatedtype AssociatedView : IView
    
    var bar: BarView? { get }
    var view: AssociatedView { get }
    var additionalContentInset: Inset { get }
    
    func apply(inset: Container.AccumulateInset)
    
}

public extension IScreenViewable {
    
    var bar: BarView? {
        return nil
    }
    
    var additionalContentInset: Inset {
        return .zero
    }
    
    func apply(inset: Container.AccumulateInset) {
    }
    
}

public extension IScreenViewable where Self : IScreen, AssociatedView == ScrollView {
    
    func apply(inset: Container.AccumulateInset, in view: ScrollView) {
        view.contentInset = inset.natural
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
