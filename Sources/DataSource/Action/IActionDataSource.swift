//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol IActionDataSource : IDataSource {
    
    var isPerforming: Bool { get }
    
}
