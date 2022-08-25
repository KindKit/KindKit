//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

public protocol IInputToolbarItem {
    
    var barItem: UIBarButtonItem { get }
    
    func pressed()
    
}

public protocol IInputToolbarView : IAccessoryView, IViewColorable {
    
    var items: [IInputToolbarItem] { set get }
    
    var size: Float { set get }
    
    var isTranslucent: Bool { set get }
    
    var barTintColor: Color? { set get }
    
    var contentTintColor: Color { set get }
    
}

public extension IInputToolbarView {
    
    @inlinable
    @discardableResult
    func items(_ value: [IInputToolbarItem]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(available value: Float) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func translucent(_ value: Bool) -> Self {
        self.isTranslucent = value
        return self
    }
    
    @inlinable
    @discardableResult
    func barTintColor(_ value: Color?) -> Self {
        self.barTintColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentTintColor(_ value: Color) -> Self {
        self.contentTintColor = value
        return self
    }
    
}

#endif
