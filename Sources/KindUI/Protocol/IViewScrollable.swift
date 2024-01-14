//
//  KindKit
//

import KindEvent
import KindMath

public protocol IViewScrollable : AnyObject {
    
    var visibleInset: Inset { set get }
    
    var contentInset: Inset { set get }
    
    var contentSize: Size { get }
    
    var isDragging: Bool { get }
    
    var isDecelerating: Bool { get }
    
    var onBeginDragging: Signal< Void, Void > { get }
    
    var onDragging: Signal< Void, Void > { get }
    
    var onEndDragging: Signal< Void, Bool > { get }
    
    var onBeginDecelerating: Signal< Void, Void > { get }
    
    var onEndDecelerating: Signal< Void, Void > { get }
    
}

public extension IViewScrollable where Self : IWidgetView, Body : IViewScrollable {
    
    @inlinable
    var visibleInset: Inset {
        set { self.body.visibleInset = newValue }
        get { self.body.visibleInset }
    }
    
    @inlinable
    var contentInset: Inset {
        set { self.body.contentInset = newValue }
        get { self.body.contentInset }
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

public extension IViewScrollable {
    
    @inlinable
    @discardableResult
    func visibleInset(_ value: Inset) -> Self {
        self.visibleInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func visibleInset(_ value: () -> Inset) -> Self {
        return self.visibleInset(value())
    }

    @inlinable
    @discardableResult
    func visibleInset(_ value: (Self) -> Inset) -> Self {
        return self.visibleInset(value(self))
    }
    
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

public extension IViewScrollable {
    
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
    func onBeginDragging< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginDragging.add(sender, closure)
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
    func onDragging< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onDragging.add(sender, closure)
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
    func onEndDragging< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onEndDragging.add(sender, closure)
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
    func onBeginDecelerating< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginDecelerating.add(sender, closure)
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
    func onEndDecelerating< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndDecelerating.add(sender, closure)
        return self
    }
    
}
