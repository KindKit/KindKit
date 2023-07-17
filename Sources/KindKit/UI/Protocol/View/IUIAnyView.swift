//
//  KindKit
//

import Foundation

public protocol IUIAnyView : AnyObject {
    
    var native: NativeView { get }
    var isLoaded: Bool { get }
    var bounds: Rect { get }
    var onAppear: Signal.Empty< Void > { get }
    var onDisappear: Signal.Empty< Void > { get }
    
    func size(available: Size) -> Size
    
    func disappear()
    
    func isChild(of view: IUIView, recursive: Bool) -> Bool
    
}

public extension IUIAnyView {
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: (() -> Void)?) -> Self {
        self.onAppear.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear(_ closure: @escaping (Self) -> Void) -> Self {
        self.onAppear.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onAppear.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ closure: (() -> Void)?) -> Self {
        self.onDisappear.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ closure: @escaping (Self) -> Void) -> Self {
        self.onDisappear.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onDisappear.link(sender, closure)
        return self
    }
    
}

public extension IUIAnyView {
    
    func isChild(of view: IUIView, recursive: Bool) -> Bool {
        guard self.isLoaded == true && view.isLoaded == true else { return false }
        return self.native.kk_isChild(of: view.native, recursive: recursive)
    }
    
    
    @inlinable
    func size(available: Size, inset: Inset) -> Size {
        return self.size(available: available.inset(inset)).inset(-inset)
    }
    
}
