//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseExpressable {
    
    func inputValues() -> [IDatabaseInputValue]
    func queryExpression() -> String
    
}
