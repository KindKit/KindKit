//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStepperView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var minValue: Float { set get }
    
    var maxValue: Float { set get }
    
    var stepValue: Float { set get }
    
    var value: Float { set get }

    var isAutorepeat: Bool { set get }
    
    var isWraps: Bool { set get }
    
    @discardableResult
    func minValue(_ value: Float) -> Self
    
    @discardableResult
    func maxValue(_ value: Float) -> Self
    
    @discardableResult
    func stepValue(_ value: Float) -> Self
    
    @discardableResult
    func value(_ value: Float) -> Self
    
    @discardableResult
    func isAutorepeat(_ value: Bool) -> Self
    
    @discardableResult
    func isWraps(_ value: Bool) -> Self
    
}
