//
//  KindKit
//

import KindEvent
import KindMath

public protocol IAnyView : AnyObject {
    
    var native: NativeView { get }
    var isLoaded: Bool { get }
    var bounds: Rect { get }
    var onAppear: Signal< Void, Void > { get }
    var onDisappear: Signal< Void, Void > { get }
    
    func size(available: Size) -> Size
    
    func disappear()
    
    func isChild(of view: IView, recursive: Bool) -> Bool
    
}

public extension IAnyView {
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: @escaping () -> Void) -> Self {
        self.onAppear.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: @escaping (Self) -> Void) -> Self {
        self.onAppear.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onAppear.add(sender, closure)
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
    func onDisappear< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onDisappear.add(sender, closure)
        return self
    }
    
}

public extension IAnyView {
    
    func isChild(of view: IView, recursive: Bool) -> Bool {
        guard self.isLoaded == true && view.isLoaded == true else { return false }
        return self.native.kk_isChild(of: view.native, recursive: recursive)
    }
    
    
    @inlinable
    func size(available: Size, inset: Inset) -> Size {
        return self.size(available: available.inset(inset)).inset(-inset)
    }
    
}
