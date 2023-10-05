//
//  KindKit
//

import Foundation

public protocol IUIView : IUIAnyView {
    
    var appearedLayout: IUILayout? { get }
    var frame: Rect { set get }
    var isHidden: Bool { set get }
    var isVisible: Bool { get }
    var onVisible: Signal.Empty< Void > { get }
    var onVisibility: Signal.Empty< Void > { get }
    var onInvisible: Signal.Empty< Void > { get }
    
    func loadIfNeeded()
    
    func setNeedForceLayout()
    func setNeedLayout()
    func layoutIfNeeded()
    
    func appear(to layout: IUILayout)
    
    func visible()
    func visibility()
    func invisible()
    
}

public extension IUIView {
    
    @inlinable
    var isAppeared: Bool {
        return self.appearedLayout != nil
    }
    
    @inlinable
    var isShowed: Bool {
        set { self.isHidden = !newValue }
        get { !self.isHidden }
    }
    
    @inlinable
    var showed: Bool {
        set { self.isShowed = newValue }
        get { self.isShowed }
    }
    
    @inlinable
    var hidden: Bool {
        set { self.isHidden = newValue }
        get { self.isHidden }
    }
    
}

public extension IUIView {
    
    @inlinable
    @discardableResult
    func frame(_ frame: Rect) -> Self {
        self.frame = frame
        return self
    }
    
    @inlinable
    @discardableResult
    func frame(_ frame: () -> Rect) -> Self {
        self.frame = frame()
        return self
    }
    
    @inlinable
    @discardableResult
    func frame(_ frame: (Self) -> Rect) -> Self {
        self.frame = frame(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func isShowed(_ value: Bool) -> Self {
        self.isShowed = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isShowed(_ value: () -> Bool) -> Self {
        return self.isShowed(value())
    }

    @inlinable
    @discardableResult
    func isShowed(_ value: (Self) -> Bool) -> Self {
        return self.isShowed(value(self))
    }
    
    @inlinable
    @discardableResult
    func isHidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isHidden(_ value: () -> Bool) -> Self {
        return self.isHidden(value())
    }

    @inlinable
    @discardableResult
    func isHidden(_ value: (Self) -> Bool) -> Self {
        return self.isHidden(value(self))
    }
    
    @inlinable
    @discardableResult
    func showed(_ value: Bool) -> Self {
        self.showed = value
        return self
    }
    
    @inlinable
    @discardableResult
    func showed(_ value: () -> Bool) -> Self {
        return self.showed(value())
    }

    @inlinable
    @discardableResult
    func showed(_ value: (Self) -> Bool) -> Self {
        return self.showed(value(self))
    }
    
    @inlinable
    @discardableResult
    func hidden(_ value: Bool) -> Self {
        self.hidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func hidden(_ value: () -> Bool) -> Self {
        return self.hidden(value())
    }

    @inlinable
    @discardableResult
    func hidden(_ value: (Self) -> Bool) -> Self {
        return self.hidden(value(self))
    }
    
}

public extension IUIView {
    
    @inlinable
    @discardableResult
    func onVisible(_ closure: (() -> Void)?) -> Self {
        self.onVisible.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ closure: @escaping (Self) -> Void) -> Self {
        self.onVisible.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onVisible.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ closure: (() -> Void)?) -> Self {
        self.onVisibility.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ closure: @escaping (Self) -> Void) -> Self {
        self.onVisibility.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onVisibility.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ closure: (() -> Void)?) -> Self {
        self.onInvisible.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ closure: @escaping (Self) -> Void) -> Self {
        self.onInvisible.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onInvisible.link(sender, closure)
        return self
    }
    
}

public extension IUIView {
    
    @inlinable
    func setNeedForceLayout() {
        self.appearedLayout?.setNeedForceUpdate(self)
    }
    
    @inlinable
    func setNeedLayout() {
        self.appearedLayout?.setNeedUpdate()
    }
    
    @inlinable
    func layoutIfNeeded() {
        self.appearedLayout?.updateIfNeeded()
    }
    
    func parent< View >(of type: View.Type) -> View? {
        guard let layout = self.appearedLayout else { return nil }
        guard let view = layout.appearedView else { return nil }
        if let view = view as? View {
            return view
        }
        return view.parent(of: type)
    }
    
    @inlinable
    func isContains(_ point: Point, from: IUIView? = nil) -> Bool {
        let localPoint = self.native.convert(point.cgPoint, from: from?.native)
        return self.native.bounds.contains(localPoint)
    }
    
    @inlinable
    func convert(_ point: Point, from: IUIView?) -> Point {
        return .init(self.native.convert(point.cgPoint, from: from?.native))
    }
    
    @inlinable
    func convert(_ point: Point, to: IUIView?) -> Point {
        return .init(self.native.convert(point.cgPoint, to: to?.native))
    }
    
    @inlinable
    func convert(_ point: Rect, from: IUIView?) -> Rect {
        return .init(self.native.convert(point.cgRect, from: from?.native))
    }
    
    @inlinable
    func convert(_ point: Rect, to: IUIView?) -> Rect {
        return .init(self.native.convert(point.cgRect, to: to?.native))
    }

}
