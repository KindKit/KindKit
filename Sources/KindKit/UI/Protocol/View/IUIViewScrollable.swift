//
//  KindKit
//

import Foundation

public protocol IUIViewScrollable : AnyObject {
    
    var visibleInset: Inset { set get }
    
    var contentInset: Inset { set get }
    
    var contentSize: Size { get }
    
    var isDragging: Bool { get }
    
    var isDecelerating: Bool { get }
    
    var onBeginDragging: Signal.Empty< Void > { get }
    
    var onDragging: Signal.Empty< Void > { get }
    
    var onEndDragging: Signal.Args< Void, Bool > { get }
    
    var onBeginDecelerating: Signal.Empty< Void > { get }
    
    var onEndDecelerating: Signal.Empty< Void > { get }
    
}

public extension IUIViewScrollable where Self : IUIWidgetView, Body : IUIViewScrollable {
    
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
    var onBeginDragging: Signal.Empty< Void > {
        self.body.onBeginDragging
    }
    
    @inlinable
    var onDragging: Signal.Empty< Void > {
        self.body.onDragging
    }
    
    @inlinable
    var onEndDragging: Signal.Args< Void, Bool > {
        self.body.onEndDragging
    }
    
    @inlinable
    var onBeginDecelerating: Signal.Empty< Void > {
        self.body.onBeginDecelerating
    }
    
    @inlinable
    var onEndDecelerating: Signal.Empty< Void > {
        self.body.onEndDecelerating
    }
    
}

public extension IUIViewScrollable {
    
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

public extension IUIViewScrollable {
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ closure: (() -> Void)?) -> Self {
        self.onBeginDragging.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginDragging.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginDragging.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ closure: (() -> Void)?) -> Self {
        self.onDragging.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ closure: @escaping (Self) -> Void) -> Self {
        self.onDragging.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onDragging.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ closure: ((Bool) -> Void)?) -> Self {
        self.onEndDragging.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onEndDragging.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onEndDragging.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ closure: (() -> Void)?) -> Self {
        self.onBeginDecelerating.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginDecelerating.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginDecelerating.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ closure: (() -> Void)?) -> Self {
        self.onEndDecelerating.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndDecelerating.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndDecelerating.link(sender, closure)
        return self
    }
    
}
