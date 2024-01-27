//
//  KindKit
//

import KindCore

public extension RangeValidator {
    
    enum Error : Swift.Error {
        
        case lessThan(limit: Limit)
        case moreThan(limit: Limit)
        
    }
    
}

extension RangeValidator.Error : Equatable {
}

extension RangeValidator.Error : Sendable {
}
