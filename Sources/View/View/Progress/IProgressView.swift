//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IProgressView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {

    var width: DimensionBehaviour { set get }
    
    var height: DimensionBehaviour { set get }
    
    var progressColor: Color { set get }
    
    var trackColor: Color { set get }
    
    var progress: Float { set get }
    
    @discardableResult
    func width(_ value: DimensionBehaviour) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour) -> Self
    
    @discardableResult
    func progressColor(_ value: Color) -> Self
    
    @discardableResult
    func trackColor(_ value: Color) -> Self
    
    @discardableResult
    func progress(_ value: Float) -> Self
    
}
