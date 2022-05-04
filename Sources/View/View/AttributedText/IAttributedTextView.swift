//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IAttributedTextView : IView, IViewDynamicSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var text: NSAttributedString { set get }
    
    var alignment: TextAlignment? { set get }
    
    var lineBreak: TextLineBreak { set get }
    
    var numberOfLines: UInt { set get }
    
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
