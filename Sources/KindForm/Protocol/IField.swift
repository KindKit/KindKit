//
//  KindKit
//

import KindCondition

public protocol IField : IEntity {
    
    var mandatory: KindCondition.IEntity { set get }
    
}

public extension IField {
    
    @inlinable
    @discardableResult
    func mandatory(_ value: KindCondition.IEntity) -> Self {
        self.mandatory = value
        return self
    }
    
}
