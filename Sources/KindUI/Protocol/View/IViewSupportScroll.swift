//
//  KindKit
//

import KindEvent
import KindMath

public protocol IViewSupportScroll : AnyObject {
    
    var contentInset: Inset { set get }
    
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

public extension IViewSupportScroll where Self : IComposite, BodyType : IViewSupportScroll {

    
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
    var contentInset: Inset {
        set { self.body.contentInset = newValue }
        get { self.body.contentInset }
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

public extension IViewSupportScroll {

    
    @inlinable
    @discardableResult
    func contentOffset(_ value: Point) -> Self {
        self.contentOffset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentOffset(_ value: () -> Point) -> Self {
        return self.contentOffset(value())
    }

    @inlinable
    @discardableResult
    func contentOffset(_ value: (Self) -> Point) -> Self {
        return self.contentOffset(value(self))
    }
    
}

public extension IViewSupportScroll {

    
    @inlinable
    @discardableResult
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: () -> Inset) -> Self {
        return self.contentInset(value())
    }

    @inlinable
    @discardableResult
    func contentInset(_ value: (Self) -> Inset) -> Self {
        return self.contentInset(value(self))
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
    func onBeginDragging< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
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
    func onDragging< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
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
    func onEndDragging< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, Bool) -> Void) -> Self {
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
    func onBeginDecelerating< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
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
    func onEndDecelerating< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
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
