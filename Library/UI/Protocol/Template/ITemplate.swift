//
//  KindKit
//

import KindLayout
import KindStyleSheet

public protocol ITemplate : Equatable {
    
    associatedtype StyleSheet : StyleSheetTrait
    
    associatedtype Layout : ILayout
    
    var layout: Layout { get }
    
    func apply(_ styleSheet: StyleSheet.Resolve)
    
}

public extension ITemplate {
    
    @inlinable
    @discardableResult
    func update(on block: () -> Void) -> Self {
        self.layout.update(on: block)
        return self
    }
    
    @inlinable
    @discardableResult
    func update(on block: (Self) -> Void) -> Self {
        return self.update(on: {
            block(self)
        })
    }
    
}

extension ITemplate where Self : AnyObject {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
}
