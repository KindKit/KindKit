//
//  KindKit
//

import Foundation

public extension Database {
    
    enum Value {
        
        case null
        case integer(Int)
        case real(Double)
        case text(String)
        case blob(Data)
        
    }
    
}
