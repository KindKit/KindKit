//
//  KindKit
//

import Foundation

public protocol IUIViewScrollable : AnyObject {
    
    var visibleInset: InsetFloat { set get }
    
    var contentInset: InsetFloat { set get }
    
    var contentSize: SizeFloat { get }
    
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
    var visibleInset: InsetFloat {
        set { self.body.visibleInset = newValue }
        get { self.body.visibleInset }
    }
    
    @inlinable
    var contentInset: InsetFloat {
        set { self.body.contentInset = newValue }
        get { self.body.contentInset }
    }
    
    @inlinable
    var contentSize: SizeFloat {
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
    func visibleInset(_ value: InsetFloat) -> Self {
        self.visibleInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: InsetFloat) -> Self {
        self.contentInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ closure: (() -> Void)?) -> Self {
        self.onBeginDragging.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ closure: ((Self) -> Void)?) -> Self {
        self.onBeginDragging.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onBeginDragging.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ closure: (() -> Void)?) -> Self {
        self.onDragging.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ closure: ((Self) -> Void)?) -> Self {
        self.onDragging.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onDragging.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ closure: ((Bool) -> Void)?) -> Self {
        self.onEndDragging.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ closure: ((Self, Bool) -> Void)?) -> Self {
        self.onEndDragging.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, Bool) -> Void)?) -> Self {
        self.onEndDragging.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ closure: (() -> Void)?) -> Self {
        self.onBeginDecelerating.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ closure: ((Self) -> Void)?) -> Self {
        self.onBeginDecelerating.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onBeginDecelerating.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ closure: (() -> Void)?) -> Self {
        self.onEndDecelerating.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ closure: ((Self) -> Void)?) -> Self {
        self.onEndDecelerating.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onEndDecelerating.set(sender, closure)
        return self
    }
    
}
