//
//  KindKitDataSource
//

import Foundation
import KindKitCore

public protocol IDataSource {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    var result: Result< Success, Failure >? { get }
    
}
