//
//  KindKit
//

import Foundation

public protocol IUIViewPageable : AnyObject {
    
    var currentPage: Double { set get }
    
    var numberOfPages: UInt { set get }
    
    var linkedPageable: IUIViewPageable? { set get }
    
    func animate(currentPage: Double, completion: (() -> Void)?)
    
}

public extension IUIViewPageable where Self : IUIWidgetView, Body : IUIViewPageable {
    
    @inlinable
    var currentPage: Double {
        set { self.body.currentPage = newValue }
        get { self.body.currentPage }
    }
    
    @inlinable
    var numberOfPages: UInt {
        set { self.body.numberOfPages = newValue }
        get { self.body.numberOfPages }
    }
    
    @inlinable
    var linkedPageable: IUIViewPageable? {
        set { self.body.linkedPageable = newValue }
        get { self.body.linkedPageable }
    }
    
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
    
}

public extension IUIViewPageable {
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Double) -> Self {
        self.currentPage = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPage(_ value: () -> Double) -> Self {
        return self.currentPage(value())
    }

    @inlinable
    @discardableResult
    func currentPage(_ value: (Self) -> Double) -> Self {
        return self.currentPage(value(self))
    }
    
    @inlinable
    @discardableResult
    func numberOfPages(_ value: UInt) -> Self {
        self.numberOfPages = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfPages(_ value: () -> UInt) -> Self {
        return self.numberOfPages(value())
    }

    @inlinable
    @discardableResult
    func numberOfPages(_ value: (Self) -> UInt) -> Self {
        return self.numberOfPages(value(self))
    }
    
    @inlinable
    @discardableResult
    func linkedPageable(_ value: IUIViewPageable?) -> Self {
        self.linkedPageable = value
        return self
    }
    
    @inlinable
    @discardableResult
    func linkedPageable(_ value: () -> IUIViewPageable?) -> Self {
        return self.linkedPageable(value())
    }

    @inlinable
    @discardableResult
    func linkedPageable(_ value: (Self) -> IUIViewPageable?) -> Self {
        return self.linkedPageable(value(self))
    }
    
}
