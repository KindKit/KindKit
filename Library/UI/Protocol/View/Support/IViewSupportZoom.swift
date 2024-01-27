//
//  KindKit
//

import KindEvent
import KindGeometry

public protocol IViewSupportZoom : AnyObject {
    
    var zoom: Double { set get }
    
    var zoomLimit: Range< Double > { set get }
    
    var isZooming: Bool { get }
    
    var onBeginZooming: Signal< Void, Void > { get }
    
    var onZooming: Signal< Void, Void > { get }
    
    var onEndZooming: Signal< Void, Void > { get }
    
}

public extension IViewSupportZoom {
    
    @inlinable
    @discardableResult
    func zoom(_ value: Double) -> Self {
        self.zoom = value
        return self
    }
    
    @inlinable
    @discardableResult
    func zoom(on: () -> Double) -> Self {
        self.zoom = on()
        return self
    }

    @inlinable
    @discardableResult
    func zoom(on: (Self) -> Double) -> Self {
        self.zoom = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func zoomLimit(_ value: Range< Double >) -> Self {
        self.zoomLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func zoomLimit(on: () -> Range< Double >) -> Self {
        self.zoomLimit = on()
        return self
    }

    @inlinable
    @discardableResult
    func zoomLimit(on: (Self) -> Range< Double >) -> Self {
        self.zoomLimit = on(self)
        return self
    }
    
}

public extension IViewSupportZoom {
    
    @inlinable
    @discardableResult
    func onBeginZooming(_ closure: @escaping () -> Void) -> Self {
        self.onBeginZooming.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginZooming(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginZooming.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginZooming< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginZooming.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming(_ closure: @escaping () -> Void) -> Self {
        self.onZooming.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming(_ closure: @escaping (Self) -> Void) -> Self {
        self.onZooming.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onZooming.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming(_ closure: @escaping () -> Void) -> Self {
        self.onEndZooming.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndZooming.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndZooming.add(sender, closure)
        return self
    }
    
}

public extension IViewSupportZoom where Self : CompositorTrait, Body : IViewSupportZoom {
    
    @inlinable
    var zoom: Double {
        set { self.body.zoom = newValue }
        get { self.body.zoom }
    }
    
    @inlinable
    var zoomLimit: Range< Double > {
        set { self.body.zoomLimit = newValue }
        get { self.body.zoomLimit }
    }
    
    @inlinable
    var isZooming: Bool {
        self.body.isZooming
    }
    
    @inlinable
    var onBeginZooming: Signal< Void, Void > {
        self.body.onBeginZooming
    }
    
    @inlinable
    var onZooming: Signal< Void, Void > {
        self.body.onZooming
    }
    
    @inlinable
    var onEndZooming: Signal< Void, Void > {
        self.body.onEndZooming
    }
    
}
