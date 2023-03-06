//
//  KindKit
//

import Foundation

public protocol IFlowPipe : ICancellable {

    func send(value: Any)
    func send(error: Any)
    
    func completed()
    
}
