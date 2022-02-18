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
    
    @discardableResult
    func items(_ value: [IInputToolbarItem]) -> Self
    
    @discardableResult
    func size(available value: Float) -> Self
    
    @discardableResult
    func translucent(_ value: Bool) -> Self
    
    @discardableResult
    func barTintColor(_ value: Color?) -> Self
    
    @discardableResult
    func contentTintColor(_ value: Color) -> Self
    
}

#endif
