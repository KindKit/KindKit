//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol ISimpleParamsActionDataSource : IActionDataSource {
    
    associatedtype Params

    func perform(_ params: Params)
    
}
