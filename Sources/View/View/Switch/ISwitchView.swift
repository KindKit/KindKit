//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ISwitchView : IView, IViewLockable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {

    var width: DimensionBehaviour { set get }
    
    var height: DimensionBehaviour { set get }
    
    var thumbColor: Color { set get }
    
    var offColor: Color { set get }
    
    var onColor: Color { set get }
    
    var value: Bool { set get }
    
    @discardableResult
    func width(_ value: DimensionBehaviour) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour) -> Self
    
    @discardableResult
    func thumbColor(_ value: Color) -> Self
    
    @discardableResult
    func offColor(_ value: Color) -> Self
    
    @discardableResult
    func onColor(_ value: Color) -> Self
    
    @discardableResult
    func value(_ value: Bool) -> Self
    
    @discardableResult
    func onChangeValue(_ value: (() -> Void)?) -> Self
    
}
