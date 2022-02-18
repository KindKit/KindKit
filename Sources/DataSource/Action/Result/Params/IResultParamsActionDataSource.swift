//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol IResultParamsActionDataSource : IActionDataSource {
    
    associatedtype Params
    associatedtype Result
    
    var result: Result? { get }

    func perform(_ params: Params)
    
}
