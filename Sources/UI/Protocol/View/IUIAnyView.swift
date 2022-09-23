//
//  KindKit
//

import Foundation

public protocol IUIAnyView : AnyObject {
    
    var native: NativeView { get }
    var isLoaded: Bool { get }
    var bounds: RectFloat { get }
    
    func size(available: SizeFloat) -> SizeFloat
    
    func disappear()
    
    func isChild(of view: IUIView, recursive: Bool) -> Bool
    
    @discardableResult
    func onAppear(_ value: ((Self) -> Void)?) -> Self
    
    @discardableResult
    func onDisappear(_ value: ((Self) -> Void)?) -> Self
    
}

public extension IUIAnyView {
    
    @inlinable
    func modify(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

public extension IUIAnyView {
    
    func isChild(of view: IUIView, recursive: Bool) -> Bool {
        guard self.isLoaded == true && view.isLoaded == true else { return false }
        return self.native.isChild(of: view.native, recursive: recursive)
    }
    
}
