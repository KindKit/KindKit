//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ISwitchView : IView, IViewStaticSizeBehavioural, IViewLockable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var thumbColor: Color { set get }
    
    var offColor: Color { set get }
    
    var onColor: Color { set get }
    
    var value: Bool { set get }
    func value(_ value: Bool) -> Self
    
    @discardableResult
    func onChangeValue(_ value: (() -> Void)?) -> Self
    
}

public extension ISwitchView {
    
    @inlinable
    @discardableResult
    func thumbColor(_ value: Color) -> Self {
        self.thumbColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func offColor(_ value: Color) -> Self {
        self.offColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onColor(_ value: Color) -> Self {
        self.onColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Bool) -> Self {
        self.value = value
        return self
    }
    
}
