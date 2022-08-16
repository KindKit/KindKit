//
//  KindKitFlow
//

import Foundation
import KindKitCore

public protocol IFlowPipe : ICancellable {

    func send(value: Any)
    func send(error: Any)
    
    func completed()
    
}
