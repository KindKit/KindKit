//
//  KindKit
//

import Foundation

public protocol IGraphicsGuide : AnyObject {
    
    associatedtype ValueType
    
    var isEnabled: Bool { set get }
    
    func guide(_ value: ValueType) -> ValueType

}

public extension IGraphicsGuide {
    
    @inlinable
    @discardableResult
    func isEnabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isEnabled(_ value: () -> Bool) -> Self {
        return self.isEnabled(value())
    }

    @inlinable
    @discardableResult
    func isEnabled(_ value: (Self) -> Bool) -> Self {
        return self.isEnabled(value(self))
    }
    
}
