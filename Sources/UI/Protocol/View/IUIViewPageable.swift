//
//  KindKit
//

import Foundation

public protocol IUIViewPageable : AnyObject {
    
    var currentPage: Float { set get }
    
    var numberOfPages: UInt { set get }
    
    var linkedPageable: IUIViewPageable? { set get }
    
    @discardableResult
    func currentPage(_ value: Float, animated: Bool, completion: (() -> Void)?) -> Self
    
}

public extension IUIViewPageable {
    
    @inlinable
    var isFirstPage: Bool {
        guard self.numberOfPages > 0 else { return false }
        return UInt(self.currentPage.roundNearest) == 0
    }
    
    @inlinable
    var isLastPage: Bool {
        guard self.numberOfPages > 0 else { return false }
        return UInt(self.currentPage.roundNearest) == self.numberOfPages - 1
    }
    
    @inlinable
    @discardableResult
    func numberOfPages(_ value: UInt) -> Self {
        self.numberOfPages = value
        return self
    }
    
    @inlinable
    @discardableResult
    func linkedPageable(_ value: IUIViewPageable?) -> Self {
        self.linkedPageable = value
        return self
    }
    
}

public extension IUIViewPageable where Self : IUIWidgetView, Body : IUIViewPageable {
    
    @inlinable
    var currentPage: Float {
        set(value) { self.body.currentPage = value }
        get { return self.body.currentPage }
    }
    
    @inlinable
    var numberOfPages: UInt {
        set(value) { self.body.numberOfPages = value }
        get { return self.body.numberOfPages }
    }
    
    @inlinable
    var linkedPageable: IUIViewPageable? {
        set(value) { self.body.linkedPageable = value }
        get { return self.body.linkedPageable }
    }
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Float, animated: Bool, completion: (() -> Void)?) -> Self {
        self.body.currentPage(value, animated: animated, completion: completion)
        return self
    }
    
}
