//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol IDataSource {
    
    associatedtype Error
    
    var error: Error? { get }
    
}
