//
//  KindKit
//

import KindEvent
import KindGeometry

public protocol IViewSupportScroll : AnyObject {
    
    var contentOffset: Point { set get }
    
    var contentSize: Size { get }
    
    var isDragging: Bool { get }
    
    var isDecelerating: Bool { get }
    
    var onBeginDragging: Signal< Void, Void > { get }
    
    var onDragging: Signal< Void, Void > { get }
    
    var onEndDragging: Signal< Void, Bool > { get }
    
    var onBeginDecelerating: Signal< Void, Void > { get }
    
    var onEndDecelerating: Signal< Void, Void > { get }
    
}

public extension IViewSupportScroll {

    
    @inlinable
    @discardableResult
    func contentOffset(_ value: Point) -> Self {
        self.contentOffset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentOffset(on: () -> Point) -> Self {
        self.contentOffset = on()
        return self
    }

    @inlinable
    @discardableResult
    func contentOffset(on: (Self) -> Point) -> Self {
        self.contentOffset = on(self)
        return self
    }
    
}

public extension IViewSupportScroll {
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ closure: @escaping () -> Void) -> Self {
        self.onBeginDragging.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginDragging.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onBeginDragging.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging(remove target: AnyObject) -> Self {
        self.onBeginDragging.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ closure: @escaping () -> Void) -> Self {
        self.onDragging.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ closure: @escaping (Self) -> Void) -> Self {
        self.onDragging.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onDragging.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(remove target: AnyObject) -> Self {
        self.onDragging.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ closure: @escaping (Bool) -> Void) -> Self {
        self.onEndDragging.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onEndDragging.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target, Bool) -> Void) -> Self {
        self.onEndDragging.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(remove target: AnyObject) -> Self {
        self.onEndDragging.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ closure: @escaping () -> Void) -> Self {
        self.onBeginDecelerating.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginDecelerating.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onBeginDecelerating.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(remove target: AnyObject) -> Self {
        self.onBeginDecelerating.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ closure: @escaping () -> Void) -> Self {
        self.onEndDecelerating.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndDecelerating.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onEndDecelerating.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(remove target: AnyObject) -> Self {
        self.onEndDecelerating.remove(target)
        return self
    }
    
}

public extension IViewSupportScroll where Self : CompositorTrait, Body : IViewSupportScroll {

    @inlinable
    var contentOffset: Point {
        set { self.body.contentOffset = newValue }
        get { self.body.contentOffset }
    }
    
    @inlinable
    var contentSize: Size {
        self.body.contentSize
    }
    
    @inlinable
    var isDragging: Bool {
        self.body.isDragging
    }
    
    @inlinable
    var isDecelerating: Bool {
        self.body.isDecelerating
    }
    
    @inlinable
    var onBeginDragging: Signal< Void, Void > {
        self.body.onBeginDragging
    }
    
    @inlinable
    var onDragging: Signal< Void, Void > {
        self.body.onDragging
    }
    
    @inlinable
    var onEndDragging: Signal< Void, Bool > {
        self.body.onEndDragging
    }
    
    @inlinable
    var onBeginDecelerating: Signal< Void, Void > {
        self.body.onBeginDecelerating
    }
    
    @inlinable
    var onEndDecelerating: Signal< Void, Void > {
        self.body.onEndDecelerating
    }
    
}
