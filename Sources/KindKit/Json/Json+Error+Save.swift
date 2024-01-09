//
//  KindKit
//

import Foundation

public extension Json.Error {

    enum Save : Swift.Error, Hashable, Equatable {
        
        case empty
        case unknown
        
    }
        
}
