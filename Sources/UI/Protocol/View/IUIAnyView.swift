//
//  KindKit
//

import Foundation

public protocol IUIAnyView : AnyObject {
    
    var native: NativeView { get }
    var isLoaded: Bool { get }
    var bounds: RectFloat { get }
    var onAppear: Signal.Empty< Void > { get }
    var onDisappear: Signal.Empty< Void > { get }
    
    func size(available: SizeFloat) -> SizeFloat
    
    func disappear()
    
    func isChild(of view: IUIView, recursive: Bool) -> Bool
    
}

public extension IUIAnyView {
    
    @inlinable
    @discardableResult
    func modify(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: (() -> Void)?) -> Self {
        self.onAppear.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: ((Self) -> Void)?) -> Self {
        self.onAppear.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onAppear.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ closure: (() -> Void)?) -> Self {
        self.onDisappear.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ closure: ((Self) -> Void)?) -> Self {
        self.onDisappear.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onDisappear.set(sender, closure)
        return self
    }
    
}

public extension IUIAnyView {
    
    func isChild(of view: IUIView, recursive: Bool) -> Bool {
        guard self.isLoaded == true && view.isLoaded == true else { return false }
        return self.native.kk_isChild(of: view.native, recursive: recursive)
    }
    
}
