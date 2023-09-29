//
//  KindKit
//

import Foundation

public protocol IMapable {
    
    func map< Result >(_ block: (Self) -> Result) -> Result

}

public extension IMapable {
    
    func map< Result >(_ block: (Self) -> Result) -> Result {
        return block(self)
    }
    
}
