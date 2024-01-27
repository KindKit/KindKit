//
//  KindKit
//

import Foundation

public protocol FromNSNumberTrait {
    
    init(truncating number: NSNumber)
    
    init?(exactly number: NSNumber)
    
}
