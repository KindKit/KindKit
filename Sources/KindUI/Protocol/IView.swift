//
//  KindKit
//

import KindEvent
import KindMath

public protocol IView : IAnyView {
    
    var appearedLayout: ILayout? { get }
    var frame: Rect { set get }
    var isHidden: Bool { set get }
    var isVisible: Bool { get }
    var onVisible: Signal< Void, Void > { get }
    var onInvisible: Signal< Void, Void > { get }
    
    func loadIfNeeded()
    
    func setNeedLayout()
    func layoutIfNeeded()
    
    func appear(to layout: ILayout)
    
    func visible()
    func invisible()
    
}

public extension IView {
    
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

public extension IView {
    
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

public extension IView {
    
    @inlinable
    @discardableResult
    func onVisible(_ closure: @escaping () -> Void) -> Self {
        self.onVisible.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ closure: @escaping (Self) -> Void) -> Self {
        self.onVisible.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onVisible.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ closure: @escaping () -> Void) -> Self {
        self.onInvisible.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ closure: @escaping (Self) -> Void) -> Self {
        self.onInvisible.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onInvisible.add(sender, closure)
        return self
    }
    
}

public extension IView {
    
    @inlinable
    func setNeedLayout() {
        self.appearedLayout?.setNeedUpdate(self)
    }
    
    @inlinable
    func layoutIfNeeded() {
        self.appearedLayout?.updateIfNeeded()
    }
    
    @inlinable
    func updateLayout() {
        self.appearedLayout?.update()
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
    func isContains(_ point: Point, from: IView? = nil) -> Bool {
        let localPoint = self.native.convert(point.cgPoint, from: from?.native)
        return self.native.bounds.contains(localPoint)
    }
    
    @inlinable
    func convert(_ point: Point, from: IView?) -> Point {
        return .init(self.native.convert(point.cgPoint, from: from?.native))
    }
    
    @inlinable
    func convert(_ point: Point, to: IView?) -> Point {
        return .init(self.native.convert(point.cgPoint, to: to?.native))
    }
    
    @inlinable
    func convert(_ point: Rect, from: IView?) -> Rect {
        return .init(self.native.convert(point.cgRect, from: from?.native))
    }
    
    @inlinable
    func convert(_ point: Rect, to: IView?) -> Rect {
        return .init(self.native.convert(point.cgRect, to: to?.native))
    }

}
