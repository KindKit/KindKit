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
    
}

public extension IStepperView {
    
    @inlinable
    @discardableResult
    func minValue(_ value: Float) -> Self {
        self.minValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maxValue(_ value: Float) -> Self {
        self.maxValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func stepValue(_ value: Float) -> Self {
        self.stepValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Float) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isAutorepeat(_ value: Bool) -> Self {
        self.isAutorepeat = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isWraps(_ value: Bool) -> Self {
        self.isWraps = value
        return self
    }
    
}
