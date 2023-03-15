//
//  KindKit
//

import Foundation

public protocol IConditionObserver : AnyObject {
    
    func changed(_ condition: ICondition)
    
}
