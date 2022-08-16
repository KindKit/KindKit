//
//  KindKitFlow
//

import Foundation
import KindKitCore

public protocol IFlowResult {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
}

extension Result : IFlowResult {
}
