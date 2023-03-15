//
//  KindKit
//

import Foundation

public protocol IFormField : IForm {
    
    var mandatory: ICondition { set get }
    
}

public extension IFormField {
    
    @inlinable
    @discardableResult
    func mandatory(_ value: ICondition) -> Self {
        self.mandatory = value
        return self
    }
    
}
