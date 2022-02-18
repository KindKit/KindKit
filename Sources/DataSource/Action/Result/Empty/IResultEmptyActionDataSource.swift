//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol IResultEmptyActionDataSource : IActionDataSource {
    
    associatedtype Result
    
    var result: Result? { get }
    
    func perform()
    
}
