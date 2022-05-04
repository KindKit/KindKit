//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IProgressView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var progressColor: Color { set get }
    
    var trackColor: Color { set get }
    
    var progress: Float { set get }
    
    @discardableResult
    func progressColor(_ value: Color) -> Self
    
    @discardableResult
    func trackColor(_ value: Color) -> Self
    
    @discardableResult
    func progress(_ value: Float) -> Self
    
}
