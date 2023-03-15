//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenViewable")
public typealias IUIScreenViewable = IScreenViewable

public protocol IScreenViewable : AnyObject {
    
    associatedtype AssociatedView : IUIView
    
    var bar: UI.View.Bar? { get }
    var view: AssociatedView { get }
    var additionalContentInset: Inset { get }
    
    func apply(inset: UI.Container.AccumulateInset)
    
}

public extension IScreenViewable {
    
    var bar: UI.View.Bar? {
        return nil
    }
    
    var additionalContentInset: Inset {
        return .zero
    }
    
    func apply(inset: UI.Container.AccumulateInset) {
    }
    
}

public extension IScreenViewable where Self : IScreen, AssociatedView == UI.View.Scroll {
    
    func apply(inset: UI.Container.AccumulateInset, in view: UI.View.Scroll) {
        view.contentInset = inset.natural
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
