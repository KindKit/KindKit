//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IAttributedTextView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var width: DimensionBehaviour? { set get }
    
    var height: DimensionBehaviour? { set get }
    
    var text: NSAttributedString { set get }
    
    var alignment: TextAlignment? { set get }
    
    var lineBreak: TextLineBreak { set get }
    
    var numberOfLines: UInt { set get }
    
    @discardableResult
    func width(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func text(_ value: NSAttributedString) -> Self
    
    @discardableResult
    func alignment(_ value: TextAlignment?) -> Self
    
    @discardableResult
    func lineBreak(_ value: TextLineBreak) -> Self
    
    @discardableResult
    func numberOfLines(_ value: UInt) -> Self
    
    @discardableResult
    func onTap(_ value: ((_ attributes: [NSAttributedString.Key: Any]?) -> Void)?) -> Self

}
