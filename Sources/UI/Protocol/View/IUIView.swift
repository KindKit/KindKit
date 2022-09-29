//
//  KindKit
//

import Foundation

public protocol IUIView : IUIAnyView {
    
    var appearedLayout: IUILayout? { get }
    var appearedItem: UI.Layout.Item? { set get }
    var isVisible: Bool { get }
    var isHidden: Bool { set get }
    
    func loadIfNeeded()
    
    func setNeedForceLayout()
    func setNeedLayout()
    func layoutIfNeeded()
    
    func appear(to layout: IUILayout)
    
    func visible()
    func visibility()
    func invisible()
    
    @discardableResult
    func onVisible(_ value: ((Self) -> Void)?) -> Self
    
    @discardableResult
    func onVisibility(_ value: ((Self) -> Void)?) -> Self
    
    @discardableResult
    func onInvisible(_ value: ((Self) -> Void)?) -> Self
    
}

public extension IUIView {
    
    @inlinable
    var isAppeared: Bool {
        return self.appearedLayout != nil
    }
    
    @inlinable
    var hidden: Bool {
        set(value) { self.isHidden = value }
        get { return self.isHidden }
    }
    
}

public extension IUIView {
    
    @inlinable
    @discardableResult
    func hidden(_ value: Bool) -> Self {
        self.isHidden = value
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
