//
//  KindKit
//

import Foundation

public protocol IDatabaseKeyPath {
    
    associatedtype ValueDecoder : IDatabaseValueDecoder

    var index: Database.Index { get }
    
}
