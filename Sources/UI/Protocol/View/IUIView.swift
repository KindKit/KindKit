//
//  KindKit
//

import Foundation

public protocol IUIView : IUIAnyView {
    
    var appearedLayout: IUILayout? { get }
    var appearedItem: UI.Layout.Item? { set get }
    var isVisible: Bool { get }
    var isHidden: Bool { set get }
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
    var hidden: Bool {
        set { self.isHidden = newValue }
        get { self.isHidden }
    }
    
}

public extension IUIView {
    
    @inlinable
    @discardableResult
    func isHidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func hide(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ closure: (() -> Void)?) -> Self {
        self.onVisible.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ closure: ((Self) -> Void)?) -> Self {
        self.onVisible.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
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
    func onVisibility(_ closure: ((Self) -> Void)?) -> Self {
        self.onVisibility.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
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
    func onInvisible(_ closure: ((Self) -> Void)?) -> Self {
        self.onInvisible.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onInvisible.link(sender, closure)
        return self
    }
    
    @inlinable
    func setNeedForceLayout() {
        if let layout = self.appearedLayout {
            if let item = self.appearedItem {
                layout.setNeedForceUpdate(item: item)
            } else {
                layout.setNeedForceUpdate()
            }
        } else if let item = self.appearedItem {
            item.setNeedForceUpdate()
        }
    }
    
    @inlinable
    func setNeedLayout() {
        self.appearedLayout?.setNeedUpdate()
    }
    
    @inlinable
    func layoutIfNeeded() {
        self.appearedLayout?.updateIfNeeded()
    }
    
}

public extension IUIView {
    
    func parent< View >(of type: View.Type) -> View? {
        guard let layout = self.appearedLayout else { return nil }
        guard let view = layout.view else { return nil }
        if let view = view as? View {
            return view
        }
        return view.parent(of: type)
    }

}
