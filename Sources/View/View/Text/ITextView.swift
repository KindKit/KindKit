//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ITextView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var width: DimensionBehaviour? { set get }
    
    var height: DimensionBehaviour? { set get }
    
    var text: String { set get }
    
    var textFont: Font { set get }
    
    var textColor: Color { set get }
    
    var alignment: TextAlignment { set get }
    
    var lineBreak: TextLineBreak { set get }
    
    var numberOfLines: UInt { set get }
    
    @discardableResult
    func width(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func text(_ value: String) -> Self
    
    @discardableResult
    func textFont(_ value: Font) -> Self
    
    @discardableResult
    func textColor(_ value: Color) -> Self
    
    @discardableResult
    func alignment(_ value: TextAlignment) -> Self
    
    @discardableResult
    func lineBreak(_ value: TextLineBreak) -> Self
    
    @discardableResult
    func numberOfLines(_ value: UInt) -> Self

}
