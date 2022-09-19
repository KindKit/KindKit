//
//  KindKit
//

import Foundation

public protocol IFlowResult {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
}

extension Result : IFlowResult {
}
