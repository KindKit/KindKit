//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindGraphics
import KindEvent
import KindLayout

public protocol IView : AnyObject, Equatable {
    
    associatedtype LayoutItem : ILayoutItem
    
    var layout: LayoutItem { get }
    
    var handle: NativeView { get }
    
    func sizeOf(_ request: SizeRequest) -> Size
    
}

public extension IView {
    
    @inlinable
    var isAppeared: Bool {
        return self.layout.position != nil
    }
    
    @inlinable
    var isLoaded: Bool {
        return self.layout.isLoaded
    }
    
    @inlinable
    var handle: NativeView {
        return self.layout.handle
    }
    
    @inlinable
    var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self.handle.bounds)
    }
    
    @inlinable
    var onAppear: Signal< Void, Bool > {
        return self.layout.onAppear
    }
    
    @inlinable
    var onDisappear: Signal< Void, Void > {
        return self.layout.onDisappear
    }
    
    @inlinable
    @discardableResult
    func lockLayout() -> Self {
        self.layout.lockUpdate()
        return self
    }
    
    @inlinable
    @discardableResult
    func unlockLayout() -> Self {
        self.layout.unlockUpdate()
        return self
    }
     
    @inlinable
    @discardableResult
    func updateLayout(force: Bool) -> Self {
        self.layout.update(force: force)
        return self
    }
    
    @inlinable
    @discardableResult
    func updateLayout(on block: () -> Void) -> Self {
        self.layout.lockUpdate()
        block()
        self.layout.unlockUpdate()
        return self
    }
    
    @inlinable
    @discardableResult
    func updateLayout(on block: (Self) -> Void) -> Self {
        return self.updateLayout(on: {
            block(self)
        })
    }
    
}

public extension IView {
    
    @inlinable
    var frame: Rect {
        set { self.layout.frame = newValue }
        get { self.layout.frame }
    }
    
    @inlinable
    @discardableResult
    func frame(_ value: Rect) -> Self {
        self.frame = value
        return self
    }
    
    @inlinable
    @discardableResult
    func frame(on: () -> Rect) -> Self {
        self.frame = on()
        return self
    }

    @inlinable
    @discardableResult
    func frame(on: (Self) -> Rect) -> Self {
        self.frame = on(self)
        return self
    }
    
}

public extension IView {
    
    @inlinable
    var isHidden: Bool {
        set { self.layout.isHidden = newValue }
        get { self.layout.isHidden }
    }
    
    @inlinable
    @discardableResult
    func isHidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isHidden(on: () -> Bool) -> Self {
        self.isHidden = on()
        return self
    }

    @inlinable
    @discardableResult
    func isHidden(on: (Self) -> Bool) -> Self {
        self.isHidden = on(self)
        return self
    }
    
}

public extension IView {
    
    @inlinable
    var hidden: Bool {
        set { self.layout.isHidden = newValue }
        get { self.layout.isHidden }
    }
    
    @inlinable
    @discardableResult
    func hidden(_ value: Bool) -> Self {
        self.hidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func hidden(on: () -> Bool) -> Self {
        self.hidden = on()
        return self
    }

    @inlinable
    @discardableResult
    func hidden(on: (Self) -> Bool) -> Self {
        self.hidden = on(self)
        return self
    }
    
}

public extension IView {
    
    @inlinable
    var isShowed: Bool {
        set { self.layout.isHidden = !newValue }
        get { !self.layout.isHidden }
    }
    
    @inlinable
    @discardableResult
    func isShowed(_ value: Bool) -> Self {
        self.isShowed = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isShowed(on: () -> Bool) -> Self {
        self.isShowed = on()
        return self
    }

    @inlinable
    @discardableResult
    func isShowed(on: (Self) -> Bool) -> Self {
        self.isShowed = on(self)
        return self
    }
    
}

public extension IView {
    
    @inlinable
    var showed: Bool {
        set { self.layout.isHidden = !newValue }
        get { !self.layout.isHidden }
    }
    
    @inlinable
    @discardableResult
    func showed(_ value: Bool) -> Self {
        self.showed = value
        return self
    }
    
    @inlinable
    @discardableResult
    func showed(on: () -> Bool) -> Self {
        self.showed = on()
        return self
    }

    @inlinable
    @discardableResult
    func showed(on: (Self) -> Bool) -> Self {
        self.showed = on(self)
        return self
    }
    
}

public extension IView {
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: @escaping (Bool) -> Void) -> Self {
        self.onAppear.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onAppear.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target, Bool) -> Void) -> Self {
        self.onAppear.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear(remove target: AnyObject) -> Self {
        self.onAppear.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ closure: @escaping () -> Void) -> Self {
        self.onDisappear.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ closure: @escaping (Self) -> Void) -> Self {
        self.onDisappear.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onDisappear.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(remove target: AnyObject) -> Self {
        self.onDisappear.remove(target)
        return self
    }
    
}

public extension IView {
    
    func isChild(of view: any IView, recursive: Bool) -> Bool {
        guard self.isLoaded == true && view.isLoaded == true else { return false }
        return self.handle.kk_isChild(of: view.handle, recursive: recursive)
    }
    
    @inlinable
    func isContains(_ point: Point, from: (any IView)? = nil) -> Bool {
        let point = self.handle.convert(point.cgPoint, from: from?.handle)
        return self.handle.bounds.contains(point)
    }
    
    @inlinable
    func isContains(_ mouse: Mouse) -> Bool {
        return self.isContains(mouse.location)
    }
    
    @inlinable
    func isContains(_ mouse: Mouse?) -> Bool {
        guard let mouse = mouse else { return false }
        return self.isContains(mouse)
    }
    
    @inlinable
    func isContains(_ touch: Touch) -> Bool {
        return self.isContains(touch.location)
    }
    
    @inlinable
    func isContains(_ touch: Touch?) -> Bool {
        guard let touch = touch else { return false }
        return self.isContains(touch)
    }
    
    @inlinable
    func isContains(_ touches: [Touch]) -> Bool {
        guard touches.isEmpty == true else { return false }
        let location = touches.map(\.location).kk_center()
        return self.isContains(location)
    }
    
    @inlinable
    func convert(_ point: Point, from: (any IView)?) -> Point {
        return .init(self.handle.convert(point.cgPoint, from: from?.handle))
    }
    
    @inlinable
    func convert(_ point: Point, to: (any IView)?) -> Point {
        return .init(self.handle.convert(point.cgPoint, to: to?.handle))
    }
    
    @inlinable
    func convert(_ point: Rect, from: (any IView)?) -> Rect {
        return .init(self.handle.convert(point.cgRect, from: from?.handle))
    }
    
    @inlinable
    func convert(_ point: Rect, to: (any IView)?) -> Rect {
        return .init(self.handle.convert(point.cgRect, to: to?.handle))
    }
    
    @inlinable
    func snapshot() -> Image? {
        guard let image = self.handle.kk_snapshot() else { return nil }
        return .init(image)
    }
    
}

extension IView {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
}

public extension IView where Self : CompositorTrait, Body : IView {
    
    @inlinable
    var layout: Body.LayoutItem {
        return self.body.layout
    }
    
    @inlinable
    func sizeOf(_ request: SizeRequest) -> Size {
        return self.body.sizeOf(request)
    }
    
}
