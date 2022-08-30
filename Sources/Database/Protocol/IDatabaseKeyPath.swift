//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseKeyPath {
    
    associatedtype ValueDecoder : IDatabaseValueDecoder

    var index: Database.Index { get }
    
}
