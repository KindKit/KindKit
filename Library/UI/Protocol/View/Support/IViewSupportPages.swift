//
//  KindKit
//

import KindGeometry

public protocol IViewSupportPages : AnyObject {
    
    var currentPage: Double { set get }
    
    var numberOfPages: UInt { set get }
    
    var linkedPageable: IViewSupportPages? { set get }
    
    @discardableResult
    func animate(currentPage: Double, completion: (() -> Void)?) -> Self
    
}

public extension IViewSupportPages {
    
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

public extension IViewSupportPages {
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Double) -> Self {
        self.currentPage = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPage(on: () -> Double) -> Self {
        self.currentPage = on()
        return self
    }

    @inlinable
    @discardableResult
    func currentPage(on: (Self) -> Double) -> Self {
        self.currentPage = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfPages(_ value: UInt) -> Self {
        self.numberOfPages = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfPages(on: () -> UInt) -> Self {
        self.numberOfPages = on()
        return self
    }

    @inlinable
    @discardableResult
    func numberOfPages(on: (Self) -> UInt) -> Self {
        self.numberOfPages = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func linkedPageable(_ value: IViewSupportPages?) -> Self {
        self.linkedPageable = value
        return self
    }
    
    @inlinable
    @discardableResult
    func linkedPageable(on: () -> IViewSupportPages?) -> Self {
        self.linkedPageable = on()
        return self
    }

    @inlinable
    @discardableResult
    func linkedPageable(on: (Self) -> IViewSupportPages?) -> Self {
        self.linkedPageable = on(self)
        return self
    }
    
}

public extension IViewSupportPages where Self : CompositorTrait, Body : IViewSupportPages {
    
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
    var linkedPageable: IViewSupportPages? {
        set { self.body.linkedPageable = newValue }
        get { self.body.linkedPageable }
    }
    
    @inlinable
    @discardableResult
    func animate(currentPage: Double, completion: (() -> Void)?) -> Self {
        return self.animate(currentPage: currentPage, completion: completion)
    }
    
}
